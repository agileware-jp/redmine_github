# frozen_string_literal: true

require_dependency 'repository/git'

class Repository::Github < ::Repository::Git
  validates_presence_of :url

  delegate :bare_clone, to: :scm
  after_create :bare_clone

  def self.scm_adapter_class
    RedmineGithub::Scm::Adapters::GithubAdapter
  end

  def self.scm_name
    'Github'
  end
end
