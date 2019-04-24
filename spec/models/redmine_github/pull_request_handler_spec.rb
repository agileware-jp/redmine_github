require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
  describe '.handle' do
    subject { RedmineGithub::PullRequestHandler.handle(payload) }

    context 'action is "opened"' do
      let(:payload) {
        { 'pull_request' => { 'html_url' => url } }
      }
      let(:url) { 'https://github.com/company/repo/pull/1' }

      it { expect { subject }.to change(PullRequest, :count).by(1) }

      it do
        subject
        expect(PullRequest.exists?(url: url)).to be true
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
