# Cleanup PR Container Action

This action is designed to clean up Business Central containers, particularly useful in cleanup scenarios or after failures.

## Example

```yaml
- name: Cleanup PR Container
  uses: ./CleanupBCContainer
  if: failure()
  with:
    shell: powershell
    pullRequestNumber: ${{ github.event.pull_request.number }}
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| shell | No | powershell | Shell in which you want to run the action (powershell or pwsh) |
| pullRequestNumber | No | ${{ github.event.pull_request.number }} | The id of the pull request |

## Use Cases

- Cleanup after failed operations
- Ensuring container resources are properly released
- Post-pipeline cleanup tasks