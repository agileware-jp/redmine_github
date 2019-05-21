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

  def login=(secret)
    # TODO encrypt
    write_attribute(:login, secret)
  end

  def login
    read_attribute(:login)
  end

  alias access_token password
  alias webhook_secret login
end
