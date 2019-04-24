module RedmineGithub
  module PullRequestHandler
    module_function

    def handle(payload)
      PullRequest.create(url: payload.dig('pull_request', 'html_url'))
      nil
    end
  end
end
