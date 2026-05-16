# AWS EC2 Monthly Billing Skill

## Overview

Retrieves the AWS bill for **EC2 (Amazon Elastic Compute Cloud)** for a user-specified month using the AWS Cost Explorer API. Run from a Python script in [scripts/get_ec2_bill.py](scripts/get_ec2_bill.py).

## When to Use

Use this skill when the user asks for:

- "EC2 bill for <month>"
- "How much did EC2 cost in <month/year>"
- "Show AWS EC2 charges for <YYYY-MM>"
- Any monthly cost breakdown for EC2 only (not other AWS services)

Do **not** use for non-EC2 services, multi-service breakdowns, or forecasts.

## Required Inputs

Before running, collect the following from the user. **Never assume or fabricate credentials.** Ask in a single prompt:

| Input                   | Required | Notes                                                                                             |
| ----------------------- | -------- | ------------------------------------------------------------------------------------------------- |
| `month`                 | Yes      | Format `YYYY-MM` (e.g. `2026-04`). Must be a complete past month or current month-to-date.        |
| `AWS_ACCESS_KEY_ID`     | Yes      | Ask the user. Treat as a secret — do not echo or log.                                             |
| `AWS_SECRET_ACCESS_KEY` | Yes      | Ask the user. Treat as a secret.                                                                  |
| `AWS_SESSION_TOKEN`     | Optional | Only if using temporary credentials (STS / SSO).                                                  |
| `AWS_REGION`            | Optional | Defaults to `us-east-1` (Cost Explorer is a global service that must be queried via `us-east-1`). |

### Credential Prompt Template

When invoked, ask the user:

> To pull the EC2 bill for **`<month>`**, I need temporary AWS credentials with `ce:GetCostAndUsage` permission. Please provide:
>
> 1. AWS Access Key ID
> 2. AWS Secret Access Key
> 3. (optional) AWS Session Token
> 4. (optional) AWS Region — defaults to `us-east-1`
>
> Credentials will be passed to the script via environment variables for this invocation only and will not be stored.

## Execution

Pass credentials to the script via environment variables (never as CLI arguments — avoids shell history leakage):

```bash
AWS_ACCESS_KEY_ID="..." \
AWS_SECRET_ACCESS_KEY="..." \
AWS_SESSION_TOKEN="..."   \
AWS_REGION="us-east-1"    \
python3 .github/skills/aws-billing/scripts/get_ec2_bill.py --month 2026-04
```

Optional flags:

- `--group-by USAGE_TYPE` (default) — breakdown by usage type (BoxUsage, EBS, DataTransfer, etc.)
- `--group-by REGION` — breakdown by AWS region
- `--group-by INSTANCE_TYPE` — breakdown by EC2 instance type
- `--json` — emit raw JSON instead of a formatted table

## Setup

One-time install:

```bash
pip install -r .github/skills/aws-billing/scripts/requirements.txt
```

## Output

The script prints:

1. Total EC2 cost (unblended USD) for the month
2. A breakdown table sorted by cost descending
3. The currency and the exact time window queried

## Required IAM Permissions

The supplied credentials must allow:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["ce:GetCostAndUsage"],
      "Resource": "*"
    }
  ]
}
```

Cost Explorer must also be enabled on the AWS account (one-time, console-only opt-in).

## Files

- [scripts/get_ec2_bill.py](scripts/get_ec2_bill.py) — main script
- [scripts/requirements.txt](scripts/requirements.txt) — Python dependencies (`boto3`)

## Restrictions

- EC2 only. The Cost Explorer filter is hard-coded to service `Amazon Elastic Compute Cloud - Compute`. To include EBS/Data Transfer broken out separately, use `--group-by USAGE_TYPE`.
- Cost Explorer data is delayed by up to 24 hours.
- Each `GetCostAndUsage` API call costs **$0.01**. The user should be aware.
- Credentials are used in-process only; do not write them to disk, logs, or git.
