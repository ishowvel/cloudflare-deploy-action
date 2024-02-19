#!/bin/bash
set -e
PROJECT=$1
DEFAULT_BRANCH=$2
DIST=$3
CURRENT_BRANCH=$4

IFS='/' read -ra fields <<<"$PROJECT"
REPOSITORY_NAME="${fields[1]}"
REPOSITORY_NAME=${REPOSITORY_NAME//./-}
# cd "$PROJECT" || exit

echo "PROJECT: $PROJECT"
echo "DEFAULT_BRANCH: $DEFAULT_BRANCH"
echo "DIST: $DIST"

echo "hard coding repository name for testing"
echo "before REPOSITORY_NAME: $REPOSITORY_NAME"
REPOSITORY_NAME="ts-template"
echo "after REPOSITORY_NAME: $REPOSITORY_NAME"

yarn add wrangler -D --frozen-lockfile
echo "Checking if project exists..."

yarn wrangler pages project list

echo "REPOSITORY_NAME: $REPOSITORY_NAME"
echo "CURRENT_BRANCH: $CURRENT_BRANCH"

# Fetch the list of projects to a temporary file
yarn wrangler pages project list >projects_list.txt

# Use grep without -q to search for the repository name, and check the command's exit status
if grep -F "$REPOSITORY_NAME" projects_list.txt; then
  echo "Project already exists. Skipping creation..."
else
  echo "Project does not exist. Creating new project..."
  yarn wrangler pages project create "$REPOSITORY_NAME" --production-branch "$DEFAULT_BRANCH"
fi

cat projects_list.txt

# output_url=$(yarn wrangler pages deploy "$DIST" --project-name "$REPOSITORY_NAME" --branch "$CURRENT_BRANCH" --commit-dirty=true)
# output_url="${output_url//$'\n'/%0A}"
# echo "DEPLOYMENT_URL=$output_url" >>"$GITHUB_ENV"

yarn wrangler pages deploy "$DIST" --project-name "$REPOSITORY_NAME" --branch "$CURRENT_BRANCH" --commit-dirty=true
