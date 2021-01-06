# actions-pr-checker
Github Action to check PR description is valid.

Validation strings are regular expressions. Don't forget to escape special chars.

## Quick start:
```yml
      - name: Run check
        uses: transferwise/actions-pr-checker@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR_NOT_CONTAINS_PATTERN: 'Why is this PR necessary?'
          PR_COMMENT: 'Please check description. \nShould be meaningful and not empty.'
```

## Parameters
| Name | Description | Default | Required |
|------|-------------|---------|:--------:|
|GITHUB_TOKEN | github bot token | | yes |
|PR_CONTAINS_PATTERN | regexp to validate PR body | `.*` | no
|PR_NOT_CONTAINS_PATTERN | regexp to validate PR body | `pseudo-long-string-constant` | |
|PR_TITLE_CONTAINS_PATTERN | regexp to validate PR title | `.*` | no
|PR_TITLE_NOT_CONTAINS_PATTERN | regexp to validate PR title | `pseudo-long-string-constant` | | 
|PR_COMMENT | Comment to add, if validation not passing| `Please check description. \nShould be meaningful and not empty.` | |
|SUCCESS_EMOJI | Reaction to PR if check success. Possible: `+1` `-1` `laugh` `confused` `heart` `hooray` `rocket` `eyes` (ref: https://developer.github.com/v3/reactions/#reaction-types) | `heart` |  |
|FAIL_CLOSES_PR | Close PR in case of check fails | false | |
|FAIL_EXITS | Fail the check if validation not passing | true | |


## More examples
PR title complies with convention
```yml

```
