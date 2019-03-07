class Repository::Github < Repository::Git
  validates_presence_of :url

  def self.scm_adapter_class
    RedmineGithub::Scm::Adapters::GithubAdapter
  end

  def self.scm_name
    'Github'
  end
end
