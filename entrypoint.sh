#!/bin/sh -l

#Get date
now=$(date -I)

# Get Github release data via GET
releaseBody=$(curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" \
--header "Authorization: token $GITHUB_TOKEN" | jq ".[] | select(.tag_name==\"$GITHUB_REF\") | .body")

# Get project id
projectId=$(curl -l -X GET "$JIRA_BASE_URL/rest/api/2/project/" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  | jq ".[] | select(.key==\"$JIRA_PROJECT_KEY\") | .id")

# Create version
curl -l -X POST "$JIRA_BASE_URL/rest/api/2/version" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  --data-raw "{
      \"description\": \"$releaseBody\",
      \"name\": \"$GITHUB_REF\",
      \"archived\": false,
      \"released\": true,
      \"releaseDate\": \"$now\",
      \"projectId\": \"$projectId\"
  }"