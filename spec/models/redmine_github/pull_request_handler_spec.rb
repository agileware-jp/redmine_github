# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
  before do
    if Setting.enabled_scm.exclude?('Github')
      Setting.enabled_scm = Setting.enabled_scm + ['Github']
    end
    allow_any_instance_of(RedmineGithub::Scm::Adapters::GithubAdapter).to receive(:bare_clone)
    graphql_mock(
      request: graphpl_json_for(:load_schema_request),
      response: graphpl_json_for(:load_schema_response)
    )
  end

  describe '.handle pull_request' do
    subject { RedmineGithub::PullRequestHandler.handle('pull_request', payload) }

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
        let!(:repository) { create :github_repository, url: 'https://github.com/company/repo.git' }
        let!(:pull_request) { create :pull_request, issue: issue, url: url }
        let(:mergeable_state) { 'DRAFT' }
        let(:merged_at) { '2019-05-08T04:01:03Z'.to_datetime }

        before do
          request = graphpl_json_for(:fetch_pr_request,
                                     repository_id: repository.id,
                                     pull_request_number: 1,
                                     repo_owner: 'company',
                                     repo_name: 'repo')
          response = graphpl_json_for(:fetch_pr_response,
                                      merged_at: merged_at,
                                      mergeable_state: mergeable_state)
          graphql_mock(request: request, response: response)
        end

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
