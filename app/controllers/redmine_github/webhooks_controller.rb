module RedmineGithub
  class WebhooksController < ApplicationController
    def dispatch_event
      head :ok
    end
  end
end
