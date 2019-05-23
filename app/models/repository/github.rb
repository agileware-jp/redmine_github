# frozen_string_literal: true

require_dependency 'repository/git'

class Repository::Github < ::Repository::Git
  has_one :github_credential, foreign_key: :repository_id
  accepts_nested_attributes_for :github_credential

  safe_attributes 'access_token', 'webhook_secret'
  validates_presence_of :url

  delegate :bare_clone, :fetch_remote, :update_remote_url, to: :scm
  after_create :bare_clone
  after_update :update_remote_url

  def self.scm_adapter_class
    RedmineGithub::Scm::Adapters::GithubAdapter
  end

  def self.scm_name
    'Github'
  end

  def scm
    unless @scm
      @scm = scm_adapter.new(url, root_url,
                             access_token, webhook_secret, path_encoding)
      update_column(:root_url, @scm.root_url.to_s) if root_url.blank? && @scm.root_url.present?
    end
    @scm
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
    assign_attributes(github_credential_attributes: { id: github_credential.id, webhook_secret: secret })
  end

  def webhook_secret
    build_github_credential if github_credential.blank?
    github_credential.webhook_secret
  end

  def owner
    scan_url if @owner.nil?
    @owner
  end

  def repo
    scan_url if @repo.nil?
    @repo
  end

  def scan_url
    @owner, @repo = url.to_s.scan(%r{https://github.com/(.+)/(.+).git}).flatten
  end
end
