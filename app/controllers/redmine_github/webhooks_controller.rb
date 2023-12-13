# frozen_string_literal: true

module RedmineGithub
  class WebhooksController < ActionController::Base
    # verifying request by X-Hub-Signature-256 header
    skip_forgery_protection if Redmine::VERSION::MAJOR >= 5

    before_action :set_repository, :verify_signature

    def dispatch_event
      event = request.headers['x-github-event']
      case event
      # As documented in: https://docs.github.com/en/webhooks/webhook-events-and-payloads
      when 'commit_comment', 'pull_request', 'pull_request_review', 'pull_request_review_comment', 'push', 'status'
        PullRequestHandler.handle(@repository, event, params)
        head :ok
      else
        # ignore
        head :ok
      end
    end

    private

    def set_repository
      @repository = Repository::Github.find(params[:repository_id])
    end

    def verify_signature
      request.body.rewind
      signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @repository.webhook_secret, request.body.read)
      head :bad_request unless Rack::Utils.secure_compare(signature, request.headers['x-hub-signature-256'])
    end
  end
end
