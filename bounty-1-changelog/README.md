# Structured changelog generator

Generate a Keep-a-Changelog-style summary from Git commit subjects since the most recent tag.

## Setup

1. Copy `changelog.sh` into a Git repository.
2. Run `chmod +x changelog.sh`.
3. Run `./changelog.sh` (or `./changelog.sh path/to/CHANGELOG.md`).

The script reads non-merge commit subjects since the latest tag, categorizes them into **Added**, **Fixed**, **Changed**, and **Removed**, then writes `CHANGELOG.md`. If the repository has no tags, it uses the full reachable history.

### Categorization

- `feat:`, `add:`, `new:` → Added
- `fix:`, `bugfix:`, `hotfix:` → Fixed
- `remove:`, `delete:`, `drop:` → Removed
- everything else → Changed

## Validation

The generator was exercised against the public `claude-builders-bounty/claude-builders-bounty` Git history. A representative generated result is included in `SAMPLE_CHANGELOG.md`.
