# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RedmineGithub::PullRequestHandler do
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

        before do
          allow_any_instance_of(PullRequest).to receive(:sync)
        end

        it { expect { subject }.to_not change(PullRequest, :count) }
      end
    end
  end

  describe '.handle pull_request_review' do
    subject { RedmineGithub::PullRequestHandler.handle('pull_request', payload) }

    let(:payload) { {} }

    it {
      expect(RedmineGithub::PullRequestHandler).to(
        receive(:handle_pull_request).with(payload)
      )
      subject
    }
  end

  describe '.handle push' do
    subject { RedmineGithub::PullRequestHandler.handle('push', payload) }

    let(:payload) { { 'ref' => ref } }
    let!(:issue) { create :issue }
    let!(:pull_request) { create :pull_request, issue: issue }

    context 'related issues exists' do
      let(:ref) { "feature/@#{issue.id}" }

      it do
        expect_any_instance_of(PullRequest).to receive(:sync)
        subject
      end
    end

    context 'related issues not exists' do
      let(:ref) { "feature/#{issue.id}" }

      it do
        expect_any_instance_of(PullRequest).to_not receive(:sync)
        subject
      end
    end
  end

  describe '.handle status' do
    subject { RedmineGithub::PullRequestHandler.handle('status', payload) }

    let(:payload) { { 'branches' => [{ name: branch }] } }
    let!(:issue) { create :issue }
    let!(:pull_request) { create :pull_request, issue: issue }

    context 'related issues exists' do
      let(:branch) { "feature/@#{issue.id}" }

      it do
        expect_any_instance_of(PullRequest).to receive(:sync).and_return(true)
        subject
      end
    end

    context 'related issues not exists' do
      let(:branch) { "feature/#{issue.id}" }

      it do
        expect_any_instance_of(PullRequest).to_not receive(:sync)
        subject
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
