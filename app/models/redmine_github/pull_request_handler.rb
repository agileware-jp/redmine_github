module RedmineGithub
  module PullRequestHandler
    module_function

    def handle(payload)
      PullRequest.create(url: payload.dig('pull_request', 'html_url'))
      nil
    end

    def extract_issue_id(branch_name)
      match = branch_name.to_s.match(/@(\d+)/)
      return nil unless match

      match.captures[0].to_i
    end
  end
end
