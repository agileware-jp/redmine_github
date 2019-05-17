# frozen_string_literal: true

require_dependency 'repository/git'

class Repository::Github < ::Repository::Git
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
end
