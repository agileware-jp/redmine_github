# frozen_string_literal: true

module RedmineGithub
  class WebhooksController < ActionController::Base
    def dispatch_event
      event = request.headers['x-github-event']
      case event
      when 'pull_request', 'pull_request_review', 'push', 'status'
        PullRequestHandler.handle(event, params)
        head :ok
      else
        # ignore
        head :ok
      end
    end
  end
end
