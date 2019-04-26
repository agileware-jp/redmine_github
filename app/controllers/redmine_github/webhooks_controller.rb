# frozen_string_literal: true

module RedmineGithub
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def dispatch_event
      if request.headers['x-github-event'] == 'pull_request'
        PullRequestHandler.handle('pull_request' => params[:pull_request])
        head :ok
      else
        head :bad_request
      end
    end
  end
end
