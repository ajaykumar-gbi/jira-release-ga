# JIRA versioning

This action uses the github release event to create a copy of the published releases into JIRA

## Environment variables
- GITHUB_TOKEN: The github token used to access the repository for which the action is running. This is used to get the body of the release and transfer it into JIRA
- JIRA_TOKEN: The base64-encoded email:api_token string for the user who is going to create the release. This user needs to have permissions to do so, as well as to retrieve information from JIRA projects 
- JIRA_PROJECT_KEY: The key of your corresponding JIRA project
- JIRA_BASE_URL: The base url for the JIRA API

## Example workflow

```
name: jira_release
on:
  release:
    types: [published]
jobs:
  jira_release:
    runs-on: ubuntu-latest
    name: JIRA release
    steps:
      - name: Jira Release
        uses: digitonic/jira-release-github-action
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          JIRA_TOKEN: ${{ secrets.JIRA_TOKEN }}
          JIRA_PROJECT_KEY: NVTM
          JIRA_BASE_URL: https://digitonic.atlassian.net

```

