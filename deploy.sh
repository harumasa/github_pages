#!/bin/zsh

LANG=C

echo -e "\033[0;33mDeploying updates to GitHub...\033[0m"

# Build the project
hugo

# Add changes to git
git add -A

# Commit changes
msg="commit `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos
git push origin master
