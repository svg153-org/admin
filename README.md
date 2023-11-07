# admin

There is a [Makefile](./Makefile) that has a few useful commands for the demo environment.

## GitHub as code

Go to `./github/settings.yml` file to change the default settings for all repositories (or not excluded) y the organization.

Go to `./github/repos/<repo-name>.yml` file to change the settings for a specific repository.

## import repositories

```bash
make import-repo repo_name=<repo-name>
```
