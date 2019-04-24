require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
  describe '.handle' do
    subject { RedmineGithub::PullRequestHandler.handle(payload) }

    let(:payload) { {} }

    it { is_expected.to be_nil }

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
end
