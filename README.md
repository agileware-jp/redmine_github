# Redmine GitHub plugin

_redmine_github_ is a Redmine plugin for connecting a local Redmine installation to a remote GitHub repository.

The plugin allows to:

- Syncronize remote GitHub repository to a local Git one. All Git-related Redmine features can be used!
- Attach pull request (PR) status icons to issues. These will change in real time, when pull request status change: created, approved, merged, etc.
- Connect git commit comments to issues via Redmine's [referencing issues in commit messages](https://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages).

## Getting started

### 1. Install the plugin

```shell
cd {LOCAL_REDMINE_DIRECTORY}/plugins
```


#### via Git clone

```shell
git clone https://github.com/agileware-jp/redmine_github.git
```

#### or from downloaded release archive file

```shell
tar xvzpf redmine_github....
```

#### Install gems and migrate the database

```shell
cd {LOCAL_REDMINE_DIRECTORY}
bundle install
bundle exec rake redmine:plugins:migrate
```

#### Restart your Redmine

After restarting check _redmine_github_ plugin is listed in `Administration->Plugins`.

### 2. Enable Github as an SCM

As per [Redmine documentation](https://www.redmine.org/projects/redmine/wiki/RedmineRepositories), enable `Github` as an SCM you wish to use globally in `Administration->Settings->Repositories->Enabled SCM`.

### 3. Add a Github repository to a Redmine project

For given project, go to its `Settings->Repositories->New Repository` form and enter:

- **SCM:** `Github`
- **Main repository:** *(Optional)*
- **Identifier:** *Put a unique repository identifier, such as the Github repository's* `Repository name`.
- **URL:** *GitHub repository's* `HTTPS URL` *; see ([clone address](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#about-remote-repositories)).*
- **Access Token:** *See [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line).*
- **Webhook Secret:** *See [webhook secret](https://developer.github.com/webhooks/securing/).*

After pressing `Create` button, a bare-clone of your Github repository will be created inside your Redmine's install directory, at `{LOCAL_REDMINE_DIRECTORY}/repositories/`.

Now use the `Edit` or `Delete` links to take note of the **Repository ID**. You will need this ID in the next step to configure the webhook URL.

### 4. Connect GitHub to Redmine

1. Go to the Github repository's **Settings**
2. Select **Webhooks** and click `Add webhook`

- **Payload URL:** `[redmine_url]/redmine_github/:repository_id/webhook`
  - *For example* `https://redmine.org/redmine_github/1/webhook`
    - *Note: replace `:repository_id` with the **Repository ID** you noted in the previous step.*
- **Content type:** `application/json`
- **Secret:** *Put the same Webhook Secret defined in Redmine project's Repository settings*
- **Which events would you like to trigger this webhook?** `Let me select individual events.`
  - `Pull requests`
  - `Pull request reviews`
  - `Pull request review comments`
  - `Pushes`
  - `Statuses`
  - `Commit comments`

### 5. Configure commit comments keywords

Use the `Administration->Settings->Repositories` tab to configure [commit comments keywords](https://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages).

## Documentation

Read [redmine_github plugin wiki pages](https://github.com/agileware-jp/redmine_github/wiki) (still WIP).

## License

Copyright &copy; 2023 [Agileware Inc.](http://agileware.jp)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
