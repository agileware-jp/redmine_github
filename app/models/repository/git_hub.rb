class Repository::GitHub < Repository
  validates_presence_of :url

  def self.scm_adapter_class
    Redmine::Scm::Adapters::GitAdapter
  end

  def self.scm_name
    'GitHub'
  end
end
