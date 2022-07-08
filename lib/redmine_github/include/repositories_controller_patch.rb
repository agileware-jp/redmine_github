# frozen_string_literal: true
require 'uri'

module RedmineGithub
  module Include
    module RepositoriesControllerPatch
      extend ActiveSupport::Concern

      class WebhookCreationError < StandardError
      end

      included do
        helper GithubHelper

        around_action :show_error_if_webhook_creation_is_failure, only: :create
      end

      private

      def repository_webhook_url
        use_hostname = ::Setting.plugin_redmine_github['webhook_use_hostname'].to_s
        return redmine_github_webhook_url(repository_id: @repository) unless use_hostname == '1'
        webhook_path = redmine_github_webhook_path(repository_id: @repository)
        "#{::Setting.protocol}://#{::Setting.host_name}#{webhook_path}"
      end

      def create_github_webhook_if_needed
        return if !@repository.is_a?(Repository::Github) || @repository.invalid?

        RedmineGithub::GithubApi::Rest::Webhook.new(@repository).create(
          config: {
            url: repository_webhook_url,
            content_type: 'json',
            secret: @repository.webhook_secret
          },
          events: %w[pull_request pull_request_review push status],
          active: true
        )
      end

      def show_error_if_webhook_creation_is_failure
        ActiveRecord::Base.transaction do
          yield

          begin
            create_github_web_hook_if_needed
          rescue => e
            logger.error("#{e.class}: #{e.message}")
            logger.debug { "backtrace:\n#{e.backtrace.join("\n")}" }
            raise WebhookCreationError
          end
        end
      rescue WebhookCreationError
        @repository.errors.add(:access_token, :invalid)

      end
    end
  end
end
