# checkout-all.sh

A utility script that clones or updates all repositories from a given GitHub organization into a specified local directory. Ideal for onboarding, code reviews, or maintaining local mirrors of organization-wide source code.

---

## Requirements

This tool requires:

### 1. GitHub CLI (gh)

Install from: https://cli.github.com/

Verify installation:

```bash
gh --version
```

### 2. Git

Make sure `git` is installed:

```bash
git --version
```

### 3. Authentication (for private repos)

If your organization contains private repositories, authenticate once:

```bash
gh auth login
```

Alternatively, set the `GH_TOKEN` environment variable with a Personal Access Token that has the necessary permissions:

```bash
export GH_TOKEN=yourtokenhere
```

For SSO-enabled organizations, make sure the PAT is authorized for the organization:

`Settings -> Developer Settings -> Personal Access Tokens -> Configure SSO -> select org and authorize`

---

## Usage

```bash
./checkout-all.sh <github-org-url> <local-target-path> [--all-branches] [--ignore=repo1,repo2]
```

### Optional Flags

#### `--all-branches`

If provided, every available branch is checked out.

When omitted, only trunk-like branches are updated:

- `main`
- `master`
- `dev`
- `develop`
- `development`

#### `--ignore=repo1,repo2`

Comma-separated list of repositories that should be skipped during clone/update operations.

Example:

```bash
--ignore=experimental-repo,legacy-service,temp-project
```

---

## Examples

### Clone/update only trunk branches

```bash
./checkout-all.sh https://github.com/my-org /home/myuser/git/my-org
```

### Clone/update all branches

```bash
./checkout-all.sh https://github.com/my-org /home/myuser/git/my-org --all-branches
```

### Ignore specific repositories

```bash
./checkout-all.sh https://github.com/my-org /home/myuser/git/my-org --ignore=repo-a,repo-b
```

### Combine both flags

```bash
./checkout-all.sh https://github.com/my-org /home/myuser/git/my-org --all-branches --ignore=repo-a,repo-b
```

> [!WARNING]
> The script discards local changes using `git reset --hard` before switching branches.

---

## License

This script is provided "as is" under the MIT license.
