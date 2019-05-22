# frozen_string_literal: true

require_dependency 'repository/git'

class Repository::Github < ::Repository::Git
  has_one :github_credential, foreign_key: :repository_id

  safe_attributes 'access_token', 'webhook_secret'
  validates_presence_of :url

  delegate :bare_clone, :fetch_remote, to: :scm
  after_create :bare_clone
  after_update :fetch_remote

  def self.scm_adapter_class
    RedmineGithub::Scm::Adapters::GithubAdapter
  end

  def self.scm_name
    'Github'
  end

  # Will be executed from background jobs as:
  # rails runner 'Repository.fetch_changesets'
  def fetch_changesets
    fetch_remote
    super
  end

  def access_token=(token)
    self.password = token
  end

  def access_token
    password
  end

  def webhook_secret=(secret)
    build_github_credential if github_credential.blank?
    github_credential.webhook_secret = secret
  end

  def webhook_secret
    build_github_credential if github_credential.blank?
    github_credential.webhook_secret
  end
end
