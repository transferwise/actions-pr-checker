# actions-pr-checker

## Usage example:
```yml
      - name: Run check
        uses: transferwise/actions-pr-checker@v1.0.0
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PULL_REQUEST_NOT_CONTAINS_PATTERN: '.*Why is this PR necessary?.*'
          PULL_REQUEST_COMMENT: 'Please check description. \nShould be meaningful and not empty.'
```

## Parameters
| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
|GITHUB_TOKEN | github bot token | | yes |
|PULL_REQUEST_CONTAINS_PATTERN | regexp to validate PR body | `.*` | no
|PULL_REQUEST_NOT_CONTAINS_PATTERN | regexp to validate PR body | `pseudo-long-string-constant` | | 
|PULL_REQUEST_COMMENT | Comment to add, if validation not passing| `Please check description. \nShould be meaningful and not empty.` | |
|SUCCESS_EMOJI | Reaction to PR if check success. \nPossible:  | `heart` |  |
|FAIL_CLOSES_PR | Close PR in case of check fails | false | |
|FAIL_EXITS | Fail the check if validation not passing | true | |
