require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
  describe '.handle' do
    subject { RedmineGithub::PullRequestHandler.handle(payload) }

    let(:payload) { {} }

    it { is_expected.to be_nil }
  end
end
