# Redmine Github plugin

_redmine_github_ is a Redmine plugin for connecting a local Redmine installation to a remote Github repository. The plugin allows to:

- Syncronize remote Github repository to a local Git one - all Git-related Redmine features can be used
- Attach pull request (PR) status icons to issues - will change in real time, when pul request status change - created, approved, merged etc.
- Connect commit comment to issues via [Redmine commit comments keywords](<(https://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages)>)

## Getting started

### 1. Install the plugin

```shell
cd {LOCAL_REDMINE_DIRECTORY}/plugins
```

#### From downloaded release archive file

```shell
tar xvzpf redmine_github....
```

#### or via Git clone

```shell
git clone https://github.com/agileware-jp/redmine_github.git
```

#### Install gems and migrate the database

```shell
cd {LOCAL_REDMINE_DIRECTORY}
bundle install
bundle exec rake redmine:plugins:migrate
```

#### Restart you Redmine

After restart, also check if plugin is listed in the installed Redmine plugins list - _(Administration|Plugins)_

### 2. Add the repository to Redmine

For given project, in \_(Settings|Repositories|New Repository) form enter:

- _SCM_ - **Github**
- _Identifier_ - uniq repository identifier
- _URL_ - GitHub repository HTTPS URL ([clone address](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#about-remote-repositories), starting with `https://`)
- _Access Token_ - [personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line)
- _Webhook Secret_ - [webhook secret](https://developer.github.com/webhooks/securing/)

After pressing _'Create'_ button, bare-clone repository will be created inside your Redmine install directory - `{LOCAL_REDMINE_DIRECTORY}/repositories/` path.

> Note the **repository ID** in the _'Edit'_ and _'Delete'_ links - you will need this for the next step (webhook url)

### 3. Connecting Github to Redmine

1. Go to the repository _Settings_ interface on GitHub.
2. Under _Webhooks_ add a new webHook:

- The _Payload URL_ needs to be of the format: `[redmine_url]/redmine_github/:repository_id/webhook` (for example `http://redmine.example.com/redmine_github/1/webhook`). Repository ID is the one of the **created in the previous step repository**
- _Content type_: **application/json**
- _Secret_: **same as Webhook Secret inside you Redmine repository settings**
- _Which events would you like to trigger this webhook?_ - _Pull requests, Pull request reviews, Pull request review comments, Pushes, Statuses, Commit comments_

### 4. Configure commit comments keywords

In _(Administration|Settings)_ , _Repositories_ tab configure [commit comments keywords](https://www.redmine.org/projects/redmine/wiki/RedmineSettings#Referencing-issues-in-commit-messages).

## Documentation

Read [redmine_github plugin wiki pages](https://github.com/agileware-jp/redmine_github/wiki) (still WIP).

## License

Copyright &copy; 2019 [Agileware Inc.](http://agileware.jp)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
