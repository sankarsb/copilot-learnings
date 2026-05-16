#!/usr/bin/env python3
"""Fetch the AWS EC2 bill for a given month via the Cost Explorer API.

Credentials are read from the standard AWS environment variables:
    AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN (optional),
    AWS_REGION (defaults to us-east-1).

Usage:
    python3 get_ec2_bill.py --month 2026-04 [--group-by USAGE_TYPE|REGION|INSTANCE_TYPE] [--json]
"""

from __future__ import annotations

import argparse
import calendar
import json
import os
import sys
from datetime import date

try:
    import boto3
    from botocore.exceptions import BotoCoreError, ClientError
except ImportError:
    sys.stderr.write(
        "boto3 is not installed. Run: pip install -r requirements.txt\n"
    )
    sys.exit(2)


EC2_SERVICE = "Amazon Elastic Compute Cloud - Compute"

GROUP_BY_MAP = {
    "USAGE_TYPE": {"Type": "DIMENSION", "Key": "USAGE_TYPE"},
    "REGION": {"Type": "DIMENSION", "Key": "REGION"},
    "INSTANCE_TYPE": {"Type": "DIMENSION", "Key": "INSTANCE_TYPE"},
}


def parse_month(value: str) -> tuple[str, str]:
    """Validate YYYY-MM and return (start_inclusive, end_exclusive) ISO dates."""
    try:
        year_str, month_str = value.split("-", 1)
        year = int(year_str)
        month = int(month_str)
        if not (1 <= month <= 12):
            raise ValueError
    except ValueError as exc:
        raise argparse.ArgumentTypeError(
            f"--month must be YYYY-MM (got {value!r})"
        ) from exc

    start = date(year, month, 1)
    last_day = calendar.monthrange(year, month)[1]
    # Cost Explorer end date is exclusive — use first day of next month.
    if month == 12:
        end = date(year + 1, 1, 1)
    else:
        end = date(year, month + 1, 1)

    # Cap end at today + 1 day if month is current/future to avoid API error.
    today = date.today()
    if start > today:
        raise argparse.ArgumentTypeError(
            f"--month {value} is in the future; no billing data available."
        )
    if end > today:
        end = today

    _ = last_day  # silence linter; used implicitly above
    return start.isoformat(), end.isoformat()


def fetch_ec2_cost(start: str, end: str, group_key: str) -> dict:
    region = os.environ.get("AWS_REGION") or "us-east-1"
    client = boto3.client("ce", region_name=region)

    kwargs = {
        "TimePeriod": {"Start": start, "End": end},
        "Granularity": "MONTHLY",
        "Metrics": ["UnblendedCost"],
        "Filter": {
            "Dimensions": {
                "Key": "SERVICE",
                "Values": [EC2_SERVICE],
            }
        },
        "GroupBy": [GROUP_BY_MAP[group_key]],
    }

    try:
        return client.get_cost_and_usage(**kwargs)
    except (BotoCoreError, ClientError) as exc:
        sys.stderr.write(f"Cost Explorer API error: {exc}\n")
        sys.exit(1)


def summarize(response: dict, group_key: str) -> tuple[float, str, list[tuple[str, float]]]:
    rows: list[tuple[str, float]] = []
    currency = "USD"
    total = 0.0

    for period in response.get("ResultsByTime", []):
        for group in period.get("Groups", []):
            key = group["Keys"][0] if group["Keys"] else "(unknown)"
            amount_obj = group["Metrics"]["UnblendedCost"]
            amount = float(amount_obj["Amount"])
            currency = amount_obj.get("Unit", currency)
            rows.append((key, amount))
            total += amount

    rows.sort(key=lambda r: r[1], reverse=True)
    return total, currency, rows


def print_table(total: float, currency: str, rows: list[tuple[str, float]],
                start: str, end: str, group_key: str) -> None:
    print(f"\nAWS EC2 bill — {start} to {end} (end exclusive)")
    print(f"Grouped by: {group_key}\n")

    if not rows:
        print("No EC2 charges found for this period.")
        print(f"\nTotal: {total:.4f} {currency}")
        return

    key_width = max(len(r[0]) for r in rows)
    key_width = max(key_width, len(group_key))
    print(f"{group_key.ljust(key_width)}   {'Cost'.rjust(14)}")
    print(f"{'-' * key_width}   {'-' * 14}")
    for key, amount in rows:
        print(f"{key.ljust(key_width)}   {amount:>14.4f}")
    print(f"{'-' * key_width}   {'-' * 14}")
    print(f"{'TOTAL'.ljust(key_width)}   {total:>14.4f}  {currency}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Fetch AWS EC2 monthly bill via Cost Explorer."
    )
    parser.add_argument("--month", required=True,
                        help="Billing month in YYYY-MM format (e.g. 2026-04)")
    parser.add_argument("--group-by", default="USAGE_TYPE",
                        choices=sorted(GROUP_BY_MAP.keys()),
                        help="Breakdown dimension (default: USAGE_TYPE)")
    parser.add_argument("--json", action="store_true",
                        help="Emit raw Cost Explorer JSON response")
    args = parser.parse_args()

    if not os.environ.get("AWS_ACCESS_KEY_ID") or not os.environ.get("AWS_SECRET_ACCESS_KEY"):
        sys.stderr.write(
            "AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be set in the environment.\n"
        )
        return 2

    start, end = parse_month(args.month)
    response = fetch_ec2_cost(start, end, args.group_by)

    if args.json:
        # Strip ResponseMetadata for cleanliness.
        response.pop("ResponseMetadata", None)
        print(json.dumps(response, indent=2, default=str))
        return 0

    total, currency, rows = summarize(response, args.group_by)
    print_table(total, currency, rows, start, end, args.group_by)
    return 0


if __name__ == "__main__":
    sys.exit(main())
