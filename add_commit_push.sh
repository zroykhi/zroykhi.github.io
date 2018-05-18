#!/bin/bash
# git add commit push in one command
# usage: bash add_commit_push.sh commit_content
#branch_name=`git symbolic-ref --short -q HEAD`
branch_name=$(git symbolic-ref --short -q HEAD)
git add .
git commit -m "$1"
git push origin "$branch_name"
