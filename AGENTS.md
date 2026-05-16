# Project Guidelines

This workspace uses VS Code custom agents in [.github/agents/](.github/agents) and skills in [.github/skills/](.github/skills).

## Custom Agents

| Agent | File | Purpose |
|-------|------|---------|
| `EC2 Billing Specialist` | [.github/agents/ec2-billing.agent.md](.github/agents/ec2-billing.agent.md) | EC2-Compute only monthly billing via the [aws-billing](.github/skills/aws-billing/SKILL.md) skill. Model: Claude Opus 4.7. |
| `Terraform Docker 9010` | [.github/agents/terraform-docker-9010.agent.md](.github/agents/terraform-docker-9010.agent.md) | Terraform → Docker container exposing host port **9010**, built on the [terrform](.github/skills/terrform/SKILL.md) skill. Model: Claude Sonnet 4.6. |

## Orchestration Rules

- The default agent acts as the **orchestrator**. It does not perform billing or terraform work itself; it delegates via subagent invocation.
- Use `runSubagent` with the agent name (case-sensitive) — `EC2 Billing Specialist` or `Terraform Docker 9010`.
- **Parallel** invocations are allowed only when the subagent tasks are fully independent (no shared inputs/outputs).
- **Sequential** invocations are required whenever one agent's output feeds another's input. The orchestrator must:
  1. Capture the subagent's structured return value verbatim.
  2. Pass only the needed fields into the next subagent's prompt.
  3. Never re-derive or fabricate values between hops.

## Pipelines

### `bill-to-html-9010` (sequential)
Goal: Display a given month's EC2 bill on `http://localhost:9010` as static HTML.

1. **Stage 1 — Billing**
   - Subagent: `EC2 Billing Specialist`
   - Input: target month (`YYYY-MM`), AWS credentials (env-var only).
   - Output: total EC2-Compute cost (USD) and `--group-by USAGE_TYPE` breakdown rows.
2. **Stage 2 — Deploy**
   - Subagent: `Terraform Docker 9010`
   - Input: the Stage 1 totals + rows, rendered into a static `index.html`.
   - Behavior: scaffold via the `terrform` skill, mount the HTML into an `nginx` container, expose host `9010 → 80`.
   - Stops before `terraform apply` for user confirmation.

## Conventions

- Credentials are passed as env vars for a single script invocation. Never echo, log, or commit them.
- No remote Terraform backend; state stays local unless requested.
- `terraform apply` and `docker run` require explicit user confirmation.
- EC2 billing scope is **Amazon EC2-Compute only**. EBS / data-transfer / other services are out of scope.

## Build / Run

- Billing script: `python3 .github/skills/aws-billing/scripts/get_ec2_bill.py --month <YYYY-MM>` (with AWS env vars).
- Terraform deploy: see [.github/skills/terrform/scripts/deploy.sh](.github/skills/terrform/scripts/deploy.sh).
