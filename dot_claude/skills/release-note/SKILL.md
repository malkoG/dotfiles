---
name: release-note
description: Generate a release changelog from git commits between the previous tag and HEAD. This skill should be used when the user wants to write release notes, generate a changelog, or summarize what changed since the last release.
---

# Release Note Generator

Generate a structured changelog from git history between the last tag and the current HEAD.

**Arguments**: `<from-ref>` (optional — defaults to the most recent `v*` tag)

## Instructions

### Phase 1: Determine Range

1. Find the previous tag:
   ```bash
   git tag --list 'v*' --sort=-version:refname | head -1
   ```
2. If `<from-ref>` is provided, use it instead.
3. Read the current version from `package.json` to use as the release title.
4. If no tags exist, use the root commit as the start.

### Phase 2: Collect Commits

Run:
```bash
git log <from-ref>..HEAD --oneline --no-merges
```

Also collect merge commits separately for PR references:
```bash
git log <from-ref>..HEAD --oneline --merges
```

### Phase 3: Categorize

Split commits into two buckets: **Features/Improvements** and **Bug Fixes**.

| Bucket | Signals |
|--------|---------|
| Features / Improvements | `feat`, `add`, `new`, `feature`, `implement`, `improve`, `enhance`, `update`, `refactor`, `optimize`, `perf`, `support` |
| Bug Fixes | `fix`, `bug`, `patch`, `resolve`, `correct` |

- Skip pure version-bump commits (e.g. "Bump version to X.Y.Z", "Bump up version to X.Y.Z").
- Skip merge commits from the main list (use them only to extract PR numbers).
- If a merge commit references a PR (e.g. `Merge pull request #123`), attach the PR number to the corresponding commits.
- Infrastructure/docs/CI commits can be omitted unless they are user-facing.

### Phase 4: Group Features by Business Impact

This is the most important step. Do NOT list feature commits flat.

1. Analyze all feature/improvement commits and cluster them by **business-level impact** — what the user or organizer actually gains. Think in terms of capabilities, not code changes.
2. Give each group a short, human-readable headline (e.g. "OAuth support", "ICS calendar feeds", "Admin group management").
3. If a group has multiple commits, list them as nested sub-items with PR numbers.
4. If a group has only one commit, it can be a single bullet with no sub-items.

### Phase 5: Format

Output the changelog in this format:

```markdown
## v{version}

### Features
- Headline for feature group A
  - Specific change 1 (#PR)
  - Specific change 2 (#PR)
- Headline for feature group B
  - Specific change (#PR)
- Single-commit feature headline (#PR)

### Bug Fixes
- Description of fix (#PR if available)
- Description of fix (#PR if available)
```

Rules:
- Omit a section entirely if it has no entries.
- Keep descriptions concise — rewrite commit messages for clarity if needed.
- Feature groups should read like a product changelog, not a git log.
- Bug fixes are listed flat, one bullet per fix. No grouping needed.

### Phase 6: Present

Display the formatted changelog to the user. Do not write it to a file unless asked.
