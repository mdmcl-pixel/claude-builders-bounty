# Structured CHANGELOG generator

Generates `CHANGELOG.md` from git commits since the latest tag. If the repository has no tags, it uses the full history.

Commits are grouped into `Added`, `Fixed`, `Changed`, and `Removed`. Conventional prefixes are recognized (`feat:`, `fix:`, `remove:` / `delete:`); uncategorized commits fall under `Changed` so nothing is silently dropped.

## Setup — 3 steps

1. Put `changelog.sh` in the repository root.
2. Run `chmod +x changelog.sh`.
3. Run `./changelog.sh` (or `./changelog.sh path/to/output.md`).

## Behaviour

- reads commits since the latest reachable git tag
- excludes merge commits
- includes short commit SHAs for traceability
- works on repositories without tags
- writes deterministic section ordering: Added → Fixed → Changed → Removed
- fails clearly when run outside a git repository

## Validation

The sample output in `SAMPLE_CHANGELOG.md` is based on the real GitHub repository `claude-builders-bounty/claude-builders-bounty`. Its observed history included `feat: initial README with bounty board` and `Initial commit`, which map to `Added` and `Changed` respectively.
