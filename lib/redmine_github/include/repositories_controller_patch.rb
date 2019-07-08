# frozen_string_literal: true

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
              url: redmine_github_webhook_url(repository_id: @repository),
              content_type: 'json',
              secret: @repository.webhook_secret
            },
            events: %w[pull_request pull_request_review push status],
            active: true
          )
        }, only: :create
      end
    end
  end
end
