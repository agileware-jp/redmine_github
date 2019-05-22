# frozen_string_literal: true

namespace :redmine_github do
  post '/:repository_id/webhook', as: 'webhook', to: 'webhooks#dispatch_event'
end
