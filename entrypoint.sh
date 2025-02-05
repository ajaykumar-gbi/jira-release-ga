#!/bin/sh -l

#Get date
now=$(date -I)
echo $GITHUB_REF
echo $TAG
ref=$(echo $GITHUB_REF  | awk -F / '{print $(NF)}')
echo $ref

curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" --header "Authorization: token $GITHUB_TOKEN" | jq ".[] | select(.tag_name==\"$TAG\") | .name"
releaseBody=$(curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY/releases" --header "Authorization: token $GITHUB_TOKEN" | jq ".[] | select(.tag_name==\"$TAG\") | .name")
echo "release body:"
echo $releaseBody

# Get project id
projectId=$(curl -l -X GET "$JIRA_BASE_URL/rest/api/2/project/" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  | jq ".[] | select(.key==\"$JIRA_PROJECT_KEY\") | .id")
echo $projectId
# Create version

echo "Version payload:"
echo "{\"description\":$releaseBody,\"name\":\"$TAG\",\"archived\":false,\"released\":true,\"releaseDate\":\"$now\",\"projectId\":$projectId}"

curl -l -X POST "$JIRA_BASE_URL/rest/api/2/version" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  --data-raw "{\"description\":$releaseBody,\"name\":\"$TAG\",\"archived\":false,\"released\":true,\"releaseDate\":\"$now\",\"projectId\":$projectId}"
