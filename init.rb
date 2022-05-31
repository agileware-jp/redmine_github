# frozen_string_literal: true

Redmine::Plugin.register :redmine_github do
  name 'Redmine Github plugin'
  author 'Agileware Inc.'
  description 'Redmine plugin for connecting to Github repositories'
  version '0.1.1'
  author_url 'https://agileware.jp/'

  settings default: { webhook_use_hostname: 0 },
           partial: 'settings/redmine_github_settings'
end

Redmine::Scm::Base.add('Github')

Rails.application.config.after_initialize do
  require File.expand_path('../lib/redmine_github', __FILE__)
  require File.expand_path('../lib/redmine_github/hooks', __FILE__)

  Issue.include RedmineGithub::Include::IssuePatch
  Issue.prepend RedmineGithub::Prepend::IssuePatch

  IssuesController.include RedmineGithub::Include::IssuesControllerPatch
  RepositoriesController.include RedmineGithub::Include::RepositoriesControllerPatch
end
