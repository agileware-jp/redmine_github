# frozen_string_literal: true

module RedmineGithub
  module PullRequestHandler
    module_function

    def handle(payload)
      issue_id = extract_issue_id(payload.dig('pull_request', 'head', 'ref'))
      return if issue_id.blank?

      PullRequest.create(
        url: payload.dig('pull_request', 'html_url'),
        issue_id: issue_id
      )
    end

    def extract_issue_id(branch_name)
      match = branch_name.to_s.match(/@(\d+)/)
      return nil unless match

      match.captures[0].to_i
    end
  end
end
