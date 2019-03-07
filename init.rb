Redmine::Plugin.register :redmine_github do
  name 'Redmine Github plugin'
  author 'Agileware Inc.'
  description 'Redmine plugin for connecting Github'
  version '0.0.1'
  author_url 'https://agileware.jp/'
end

Redmine::Scm::Base.add('Github')

RedmineGithub::Reloader.to_prepare do
  RepositoriesController.helper GithubHelper
end
