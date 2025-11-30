# checkout-all.sh

A utility script that clones or updates all repositories from a given GitHub organization into a specified local directory. Ideal for onboarding, code reviews, or maintaining local mirrors of organization-wide source code.

---

## Requirements

This tool requires:

### 1. GitHub CLI (gh)

Install from: [https://cli.github.com/](https://cli.github.com/)

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

Alternatively, just set GH_TOKEN environment variable with a Personal Access Token with the necessary access.

```bash
export GH_TOKEN=yourtokenhere
```

For SSO enabled orgs, make sure the PAT is authorized for the org (Settings -> Developer Settings -> Personal Access Tokens -> Configure SSO -> select org and authorize)


---

## Usage

```bash
./checkout-all.sh <github-org-url> <local-target-path> [--all-branches]
```

* `--all-branches`: If provided, every available branch is checked out. When not provided, only `trunk` branches will be checked out, namely `main`, `master`, `dev`, `develop` and `development`.

```

### Example

```bash
./checkout-all.sh https://github.com/my-org /home/myuser/git/my-org
```

> [!WARNING]
> The script discards local changes!


---

## License

This script is provided "as is" under the MIT license.
