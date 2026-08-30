# Weekly GitHub Dev Summary (n8n)

This workflow implements bounty #5. It runs weekly, collects the previous seven days of GitHub commits, closed issues, and merged pull requests, asks Claude to write a narrative summary, and posts the result to Slack.

## Setup — 5 steps

1. Import `weekly-dev-summary.json` into n8n.
2. Set n8n environment variables `GITHUB_TOKEN`, `ANTHROPIC_API_KEY`, and `SLACK_WEBHOOK_URL`. Use least-privilege credentials and do not place secrets inside the workflow JSON.
3. Open the **Config** node and set `repo` to `owner/repository`, `language` to `EN` or `FR`, and `destination` to `Slack`.
4. Run the workflow manually once and confirm the GitHub requests, Claude response, and Slack delivery all succeed.
5. Capture a screenshot of the successful n8n execution, then activate the workflow. The schedule is Friday at 17:00 in the n8n instance timezone.

## What it does

- Weekly Schedule Trigger: Friday at 17:00.
- GitHub API: fetches commits from the last seven days.
- GitHub API: fetches recently closed issues and removes pull-request-shaped issue records.
- GitHub API: fetches closed pull requests and keeps only PRs merged during the last seven days.
- Claude Messages API: uses `claude-sonnet-4-20250514` to produce a concise narrative without inventing activity.
- Slack Incoming Webhook: posts the generated summary.

## Configuration

The **Config** node contains the non-secret variables required by the bounty:

- `repo`: GitHub repository in `owner/repository` form.
- `language`: `EN` or `FR`.
- `destination`: documented as `Slack` for this implementation.

Secrets are read at runtime from n8n environment variables. No token or webhook value is committed.

## Validation status

The workflow file is designed to be importable into n8n and contains the requested schedule, GitHub collection, Claude generation, and Slack delivery path. A real n8n execution and screenshot are intentionally **not claimed here** because they have not been performed in this environment. The bounty requires that final runtime evidence before submission can truthfully claim full acceptance-criteria validation.
