# frozen_string_literal: true
require 'uri'

module RedmineGithub
  module Include
    module RepositoriesControllerPatch
      extend ActiveSupport::Concern

      included do
        helper GithubHelper

        after_action lambda {
          return if !@repository.is_a?(Repository::Github) || @repository.invalid?

          RedmineGithub::GithubAPI::Rest::Webhook.new(@repository).create(
            config: {
              url: repository_webhook_url,
              content_type: 'json',
              secret: @repository.webhook_secret
            },
            events: %w[pull_request pull_request_review push status],
            active: true
          )
        }, only: :create
      end

      def repository_webhook_url
        use_hostname = ::Setting.plugin_redmine_github['webhook_use_hostname'].to_s
        return redmine_github_webhook_url(repository_id: @repository) unless use_hostname == '1'
        webhook_path = redmine_github_webhook_path(repository_id: @repository)
        "https://#{::Setting.host_name}#{webhook_path}"
      end
    end
  end
end
