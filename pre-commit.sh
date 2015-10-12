#! /bin/sh

# If eslint isn't available, try to install it. If you can't, fail
# commit.
ESLINT_LOCATION=$(which eslint)
if [ ! $ESLINT_LOCATION ]; then
    echo "\n  \033[32mESlint is not yet installed! Attempting to install it now...\n"
    npm install -g eslint
    installed=$?

    if [ "$installed" != "0" ]; then
        echo "\n\t\033[1;31mFailed to install eslint!\033[0;37m"
        echo "Git pre-commit hooks cannot run. Exiting without committing.\n"
        exit 1
    else
        echo "\t\033[32mESLint was installed successfully.\n\033[0;37m"
    fi
fi

# By default, we will pass
pass=true


echo "\nRunning ESLint on files before committing...\n"
FILES=$(git diff --cached --name-only --diff-filter=ACM | grep \.js$)

# Politeness
if [ "$FILES" == "" ]; then
    echo 'No files in this commit need linting'
    exit 0
fi

# Report for each file being linted
for file in ${FILES}; do
    eslint --fix ${file}

    result=$?

    if [ "$result" = "0" ]; then
        echo "\t\033[32mLinting tests passed: ${file}\033[0m"
    else
        pass=false
    fi
done

if ! $pass; then
    echo $(cat <<EOF

   \033[41mCOMMIT FAILED:\033[0m Your commit contains files that failed to meet our JS standards.\n
                  Please fix the errors and try again.   For help, see the .eslintrc configuration. \n\n
                  If you are really in a bind, run git commit with --no-verify to skip this pre-commit hook.
EOF
           )
    exit 1
else
    exit 0
fi

