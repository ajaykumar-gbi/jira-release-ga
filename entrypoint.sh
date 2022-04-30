#!/bin/sh -l

#Get date
now=$(date -I)
#ref=$(curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY_OWNER/$GITHUB_REPOSITORY/releases/latest" | jq ".tag_name" )
ref=$(echo $GITHUB_REF | grep -o -E "\d+\.\d+\.*\d*")
echo $ref
# Get Github release data via GET
curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY_OWNER/$GITHUB_REPOSITORY/releases/latest" --header "Authorization: token $GITHUB_TOKEN" | jq ".body"
releaseBody=$(curl --location --request GET "https://api.github.com/repos/$GITHUB_REPOSITORY_OWNER/$GITHUB_REPOSITORY/releases/latest" --header "Authorization: token $GITHUB_TOKEN" | jq ".body")
echo $releaseBody

# Get project id
projectId=$(curl -l -X GET "$JIRA_BASE_URL/rest/api/2/project/" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  | jq ".[] | select(.key==\"$JIRA_PROJECT_KEY\") | .id")
echo $projectId
# Create version

echo "Version payload:"
echo "{\"description\":$releaseBody,\"name\":\"$ref\",\"archived\":false,\"released\":true,\"releaseDate\":\"$now\",\"projectId\":$projectId}"

curl -l -X POST "$JIRA_BASE_URL/rest/api/2/version" \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $JIRA_TOKEN" \
  --data-raw "{\"description\":\"$releaseBody\",\"name\":\"$ref\",\"archived\":false,\"released\":true,\"releaseDate\":\"$now\",\"projectId\":$projectId}"
