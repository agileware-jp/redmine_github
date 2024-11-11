# frozen_string_literal: true

module RedmineGithub
  class << self
    def host_uri
      self_hosted_uri || URI('https://github.com')
    end

    def api_base_uri
      self_hosted_uri ? self_hosted_uri + 'api/v3' : URI('https://api.github.com')
    end

    private

    def self_hosted_uri
      url = ENV['REDMINE_GITHUB_SELF_HOSTED_URL'].presence
      url ? URI(url.sub(%r{/\z}, '')) : nil
    end
  end

  def self.rails5_or_later?
    Rails::VERSION::MAJOR >= 5
  end
end
