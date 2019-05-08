# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
  describe '.handle' do
    subject { RedmineGithub::PullRequestHandler.handle(payload) }

    context 'action is "opened"' do
      let(:payload) do
        {
          'pull_request' => {
            'html_url' => url,
            'head' => {
              'ref' => ref
            },
            'merged_at' => merged_at
          }
        }
      end
      let(:url) { 'https://github.com/company/repo/pull/1' }
      let(:issue) { create :issue }
      let(:merged_at) { nil }

      context 'when the branch has an issue ID' do
        let(:ref) { "feature/@#{issue.id}-my_first_pr" }

        it { expect { subject }.to change { PullRequest.exists?(url: url, issue_id: issue.id) }.to true }
        it { expect { subject }.to change(PullRequest, :count).by(1) }
      end

      context 'when the branch does not have an issue ID' do
        let(:ref) { "feature/#{issue.id}-my_first_pr" }

        it { expect { subject }.not_to change(PullRequest, :count) }
      end

      context 'when a issue has pull request' do
        let(:ref) { "feature/@#{issue.id}-my_first_pr" }
        let(:merged_at) { '2019-05-08T04:01:03Z'.to_datetime }
        let!(:pull_request) { create :pull_request, issue: issue, url: url }

        it { expect { subject }.to_not change(PullRequest, :count) }
        it { expect { subject }.to(change { pull_request.reload.merged_at }.from(nil)) }
      end
    end
  end

  describe '.extract_issue_id' do
    subject { RedmineGithub::PullRequestHandler.extract_issue_id(branch_name) }

    context 'when branch_name has an @{issue_id}' do
      let(:branch_name) { 'feature/@1234-my_first_pr' }
      it { is_expected.to eq 1234 }
    end

    context 'when branch_name has a number without @' do
      let(:branch_name) { 'feature/1234-my_first_pr' }
      it { is_expected.to be_nil }
    end
  end
end
