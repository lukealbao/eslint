# ESlint help
Use this for quality management for your JS code.

## To use
1. Put `.eslintrc` and `.esignore` in the root of your project directory
2. Put `pre-commit.sh` in your `.git/hooks/` directory.

## Caveats
- The `pre-commit` shell script will need to be executable.
- `npm install` must be available without running sudo. If `ESLint` is
  not installed, then the pre-commit hook will install it for you.
