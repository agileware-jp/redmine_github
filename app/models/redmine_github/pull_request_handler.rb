# frozen_string_literal: true

module RedmineGithub
  module PullRequestHandler
    module_function

    def handle(event, payload)
      send("handle_#{event}", payload)
    end

    def extract_issue_id(branch_name)
      match = branch_name.to_s.match(/@(\d+)/)
      return nil unless match

      match.captures[0].to_i
    end

    def handle_pull_request(payload)
      issue = Issue.find_by(id: extract_issue_id(payload.dig('pull_request', 'head', 'ref')))
      return if issue.blank?

      pull_request = PullRequest.find_or_create_by(
        issue: issue,
        url: payload.dig('pull_request', 'html_url')
      )

      pull_request.update(merged_at: payload.dig('pull_request', 'merged_at'))
    end

    def pull_request_review(payload)
      issue = Issue.find_by(id: extract_issue_id(payload.dig('pull_request', 'head', 'ref')))
      return if issue.blank?

      pull_request = PullRequest.find_or_create_by(
        issue: issue,
        url: payload.dig('pull_request', 'html_url')
      )

      pull_request.sync
    end

    def handle_push(payload)
      issue = Issue.find_by(id: extract_issue_id(payload.dig('ref')))
      return if issue.blank?

      pull_request = PullRequest.find_by(issue: issue)
      pull_request.try!(:sync)
    end

    def handle_status(payload)
      issue_ids = payload.dig('branches').map { |b| extract_issue_id(b[:name]) }.compact.uniq
      PullRequest.where(issue_id: issue_ids).find_each(&:sync)
    end
  end
end
