namespace :redmine_github do
  post '/webhook/', as: 'webhook', to: 'webhooks#dispatch_event'
end