# CreatePRContainer

Creates or configures a Business Central container for pull request validation. If the container already exists, it will be started and reconfigured. Any existing TRASER apps will be uninstalled to ensure a clean state.

## INPUT

### ENV variables

| Name | Description |
| :-- | :-- |
| BC_LICENSE | Business Central license file content |
| BC_VERSION | Business Central version to use |
| CONTAINER_USERNAME | Username for the container (default: traser) |
| CONTAINER_PASSWORD | Password for the container |
| NUGET_FEEDS_TOKEN | Token for accessing NuGet feeds |

### Parameters

| Name | Required | Description | Default value |
| :-- | :-: | :-- | :-- |
| shell | | Shell in which you want to run the action | powershell |
| runs-on | Yes | The type of runner to run the job on | |
| pullRequestNumber | | The ID of the pull request | github.event.pull_request.number |

## OUTPUT

The action creates or reconfigures a container with the following characteristics:
- Container name will be "pr" + pullRequestNumber
- All TRASER apps are uninstalled to ensure clean state
- Required dependencies are downloaded and installed
- NuGet packages are configured with provided token
- Container is configured with specified credentials and license