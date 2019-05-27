# frozen_string_literal: true

Redmine::Plugin.register :redmine_github do
  name 'Redmine Github plugin'
  author 'Agileware Inc.'
  description 'Redmine plugin for connecting to Github repositories'
  version '0.0.1'
  author_url 'https://agileware.jp/'
end

Redmine::Scm::Base.add('Github')

RedmineGithub::Reloader.to_prepare do
  require_dependency 'redmine_github/hooks'

  RepositoriesController.helper GithubHelper
  User.include RedmineGithub::UserPatch

  Issue.include RedmineGithub::Include::IssuePatch
  Issue.prepend RedmineGithub::Prepend::IssuePatch

  IssuesController.include RedmineGithub::Include::IssuesControllerPatch
end
