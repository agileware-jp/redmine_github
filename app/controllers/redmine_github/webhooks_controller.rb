module RedmineGithub
  class WebhooksController < ApplicationController
    def dispatch_event
      if request.headers['x-github-event'] == 'pull_request'
        head :ok
      else
        head :bad_request
      end
    end
  end
end
