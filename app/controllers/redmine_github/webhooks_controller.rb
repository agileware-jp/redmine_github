# frozen_string_literal: true

module RedmineGithub
  class WebhooksController < ActionController::Base
    before_action :set_repository, :verify_signature
    def dispatch_event
      event = request.headers['x-github-event']
      case event
      when 'pull_request', 'pull_request_review', 'push', 'status'
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
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), @repository.webhook_secret, request.body.read)
      head :bad_request unless Rack::Utils.secure_compare(signature, request.headers['x-hub-signature'])
    end
  end
end
