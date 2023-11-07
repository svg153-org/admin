# admin

There is a [Makefile](./Makefile) that has a few useful commands for the demo environment.

## safe-settings app

Go to [safe-settings-local](./apps/safe-settings-local) to see how to deploy the [github/safe-settings][github-safe-settings] in a local environment.

## GitHub as code

Go to `./github/settings.yml` file to change the default settings for all repositories (or not excluded) y the organization.

Go to `./github/repos/<repo-name>.yml` file to change the settings for a specific repository.

## Docs

![/assets/safe-settings_space.jpg](/assets/safe-settings_space.jpg)

![/assets/safe-settings_demo_pipeline.jpg](/assets/safe-settings_demo_pipeline.jpg)

For more details about the settings, please check the [sequence diagram](/assets/safe-settings_sequence.jpg)

## import repositories

```bash
make import-repo repo_name=<repo-name>
```

<!-- Links -->
[github-safe-settings]: https://github.com/github/safe-settings
