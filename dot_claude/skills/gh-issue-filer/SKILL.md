---
name: gh-issue-filer
description: This skill should be used when the user wants to file a GitHub issue, create a bug report, request a feature, report a problem, or open an issue in the current repository. It explores the codebase to understand project context, gathers issue details through conversation, and files the issue via the gh CLI. Trigger phrases include "file an issue", "create an issue", "report a bug", "request a feature", "open an issue", or "gh issue".
---

# GitHub Issue Filer

File GitHub issues with codebase-aware context gathering and structured body generation.

**Arguments**: `description` (optional initial description of the issue)

## Prerequisites

- The `gh` CLI must be installed and authenticated (`gh auth status`)
- The working directory must be inside a git repository with a GitHub remote

## Workflow

### Phase 1: Environment Validation

Run the following checks before proceeding:

1. Verify `gh` is available and authenticated:
   ```bash
   gh auth status
   ```
2. Verify a GitHub remote exists and capture the repo identifier:
   ```bash
   gh repo view --json nameWithOwner -q .nameWithOwner
   ```
3. If either check fails, inform the user and halt. Suggest `gh auth login` for auth failures.

### Phase 2: Codebase Exploration

Gather project context silently (do not ask the user for this information). Perform these
steps concurrently where possible:

1. **Detect tech stack** — Check for project descriptor files:
   - `package.json` (Node/JS/TS ecosystem, frameworks, key dependencies)
   - `Cargo.toml` (Rust)
   - `pyproject.toml` or `requirements.txt` (Python)
   - `go.mod` (Go)
   - `Gemfile` (Ruby)
   - `build.gradle` or `pom.xml` (JVM)
   - `CLAUDE.md` or `AGENTS.md` (project-specific instructions and architecture notes)
   - `README.md` (project description)

2. **Identify directory structure** — Run `ls` at the project root to understand layout.

3. **Check recent changes** — Run `git log --oneline -10` to understand recent development activity.

4. **Discover available labels** — Run `gh label list --json name,description` to know what labels exist.

5. **Check for issue templates** — Look for `.github/ISSUE_TEMPLATE/` directory. If templates exist,
   note their names for use with `--template` flag.

6. **Check existing open issues** — Run `gh issue list --limit 10 --state open --json number,title,labels`
   to avoid duplicates and understand current issue patterns.

Store all gathered context internally for use when generating the issue body.

### Phase 3: Conversational Gathering

Ask the user for issue details interactively. Adapt the conversation based on what the user
has already provided (e.g., if invoked with a description argument, skip asking for it).

**Question 1: Issue type** (if not already clear from context)

Ask what kind of issue this is using AskUserQuestion. Suggest options based on available labels:
- Bug report
- Feature request / enhancement
- Documentation improvement
- Question / discussion

**Question 2: Title and description**

If no description was provided as an argument, ask the user to describe the issue:

> "Describe the issue. A brief summary is fine — include as much or as little detail as needed."

If a description was provided, use it and skip this question.

**Question 3: Additional details** (conditional, based on issue type)

For **bug reports**, ask:
> "Any additional context? Steps to reproduce, expected vs actual behavior, or which part of
> the codebase is affected. (Skip if not applicable.)"

For **feature requests**, ask:
> "Any additional context? Motivation, proposed approach, or which area of the codebase this
> would touch. (Skip if not applicable.)"

For other types, skip this question unless the description is very sparse.

**Question 4: Draft review**

Present a draft showing:
- Generated title
- Suggested labels (auto-detected from issue type, only from available labels)
- Generated body

Ask the user to confirm, adjust, or cancel using AskUserQuestion with options:
- "File as-is"
- "Edit title or labels"
- "Cancel"

### Phase 4: Issue Body Generation

Generate a structured issue body adapted per type. Omit sections that have no useful content.
Never generate placeholder text like "[TODO]" in the filed issue.

#### Bug Report

```markdown
## Summary
[Clear description of the bug]

## Steps to reproduce
1. [Step 1]
2. [Step 2]

## Expected behavior
[What should happen]

## Actual behavior
[What actually happens]

## Context
- **Relevant area**: [detected from description + codebase structure]
```

#### Feature Request / Enhancement

```markdown
## Summary
[Clear description of the feature or enhancement]

## Motivation
[Why this is needed]

## Proposed approach
[If the user provided one, otherwise omit]

## Context
- **Relevant area**: [detected from description + codebase structure]
```

#### Minimal (for simple issues or other types)

```markdown
## Summary
[Description]

## Context
- **Area**: [relevant area if identifiable]
```

### Phase 5: Filing

1. Construct and run the `gh issue create` command:
   ```bash
   gh issue create \
     --title "the title" \
     --label "label1,label2" \
     --body "$(cat <<'EOF'
   ## Summary
   ...
   EOF
   )"
   ```

2. If issue templates exist in the repo and one matches the issue type, consider using
   `--template "Template Name"` instead of `--body`.

3. After filing, display the issue URL to the user.

## Label Auto-Detection

Map issue types to common GitHub labels. Only suggest labels that actually exist in the repo
(from the `gh label list` output in Phase 2):

| Issue Type | Candidate Labels |
|------------|-----------------|
| Bug | `bug` |
| Feature | `enhancement` |
| Documentation | `documentation` |
| Question | `question` |
| Beginner-friendly | `good first issue` |

If the user mentions something needs help or attention, also suggest `help wanted`.

## Quick Mode

When the user provides enough detail upfront (e.g., invoked with a full description argument),
minimize questions:

1. Run Phase 1 and Phase 2
2. Infer issue type from the description
3. Skip to Phase 4, generating from the provided description
4. Show the draft and ask for confirmation
5. File on confirmation

## Umbrella Issues

When the user wants to file an **umbrella issue** (also known as a tracking issue, epic, or parent issue that groups related sub-issues), the title **MUST** include a prefix in the format `[Category]`.

- Force the user to provide a prefix category. Do not allow filing an umbrella issue without one.
- Suggest `[Admin]` as the default prefix if the user does not specify one.
- Examples of valid umbrella issue titles:
  - `[Admin] Set up CI/CD pipeline`
  - `[Auth] Implement OTP login flow`
  - `[Federation] ActivityPub compliance improvements`
- If the user tries to file an umbrella issue without a prefix, ask them to choose or provide one before proceeding.
- Detect umbrella issues by keywords like "umbrella", "tracking issue", "epic", "parent issue", or when the user explicitly mentions grouping multiple sub-tasks/issues.

## Error Handling

- If `gh auth status` fails: suggest `gh auth login`
- If no GitHub remote: suggest adding a remote or `gh repo create`
- If `gh issue create` fails: show the error and offer to retry
- If the user cancels at any point: confirm and halt gracefully
