# safe-settings-local

## Create the GitHub safe-settings App

TL;DR: Check this [video to see how to create the GitHub App](https://www.youtube.com/watch?v=KmAyPUv9gOY), but with this permissions and events.

### Steps

Go to the organization settings and in the [Developer settings -> GitHub Apps](https://github.com/organizations/svg153-org/settings/apps) section, click on the New GitHub App button.

Enter the name and URL. In the URL, we can put our GitHub organization's URL.

In the Webhook section, we disable it for now. When we have the URL, we will add it.

Let's configure the permissions:

- Repository permissions:
    - Administration: Read & Write
    - Checks: Read & Write
    - Commit statuses: Read & Write
    - Contents: Read & Write
    - Issues: Read & Write
    - Metadata (mandatory): Read-only
    - Pull requests: Read & Write
    - Workflows: Read & Write
- Organization permissions:
    - Administration: Read & Write
    - Members: Read & Write
- Account permissions:
    - All with No Access

Let's configure the events: <https://github.com/github/safe-settings?tab=readme-ov-file#events>

- Branch protection rule
- Check run
- Check suite
- Member
- Pull request
- Push
- Repository
- Repository ruleset
- Team

<!-- [`member_change_events`](https://github.com/github/safe-settings/blob/e584dbc552df2674186d61c7a17c040dafade634/index.js#L307) -->

To check the permissions that our app has, we can do it with the following command:

```shell
your_app_name="safe-settings-svg153-org"
gh api \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /apps/${your_app_name}
```

We only allow it to be installed in our organization. To do this, we go to `Where can this GitHub App be installed?` and select `Only on this account`.

Now we have everything, we can click on `Create GitHub App`.

Once created, we go back to [Developer settings -> GitHub Apps](https://github.com/organizations/svg153-org/settings/apps), and our app will appear there. Click on `Edit`.

Now within the app configuration, click on the left side on `Install App`.

- Our organization will appear there and we click on `Install`.
- We will see a summary of the permissions and where we want to install it, whether in all repositories or only in some.
    - In our case, in the organization.
    - Click on `Install`.
- It redirects us to the page of the apps installed in our organization.

## Start

Your need and app created and configured.

1. Create a `.env` file from the `.env.example` and fill the variables.
2. Run `make up` to start safe-settings application
3. Run `make open` to open the port 3000 for incoming webhooks from GitHub.
    - Copy the URL and paste in the GitHub App settings in the field `Webhook URL` and save.
4. Now you can use safe-settings in your organization.
