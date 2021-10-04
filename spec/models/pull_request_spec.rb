# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe PullRequest do
  describe 'validation URL' do
    let(:pull_request) { build :pull_request, url: nil }

    it do
      pull_request.valid?
      expect(pull_request.errors.full_messages).to include 'URL を入力してください'
    end
  end

  describe '#state' do
    subject { pull_request.state }

    let(:pull_request) { create :pull_request, merged_at: merged_at, mergeable_state: mergeable_state }

    context 'when merged_at is not nil' do
      let(:merged_at) { Time.current }
      let(:mergeable_state) { 'UNKNOWN' }

      it { is_expected.to eq(:merged) }
    end

    context 'when merged_at is nil and mergeable_state is CLEAN' do
      let(:merged_at) { nil }
      let(:mergeable_state) { 'CLEAN' }

      it { is_expected.to eq(:mergeable) }
    end

    context 'when merged_at is nil and mergeable_state is not CLEAN' do
      let(:merged_at) { nil }
      let(:mergeable_state) { 'BLOCKED' }

      it { is_expected.to eq(:opened) }
    end
  end

  describe '#repo_owner' do
    subject { pull_request.repo_owner }
    let(:pull_request) { create :pull_request, url: 'https://github.com/owner/repo/pull/1' }

    it { is_expected.to eq('owner') }
  end

  describe '#repo_name' do
    subject { pull_request.repo_name }
    let(:pull_request) { create :pull_request, url: 'https://github.com/owner/repo/pull/1' }

    it { is_expected.to eq('repo') }
  end

  describe '#number' do
    subject { pull_request.number }
    let(:pull_request) { create :pull_request, url: 'https://github.com/owner/repo/pull/1' }

    it { is_expected.to eq(1) }
  end

  describe '#repository' do
    subject { pull_request.repository }

    let!(:pull_request) { create :pull_request, url: 'https://github.com/owner/repo/pull/1' }
    let!(:repository) { create :github_repository, url: 'https://github.com/owner/repo.git' }

    it { is_expected.to eq(repository) }
  end

  describe '#sync' do
    subject { pull_request.sync }

    let!(:pull_request) { create :pull_request, url: 'https://github.com/owner/repo/pull/1' }

    before do
      repository = create :github_repository, url: 'https://github.com/owner/repo.git'
      client_stub = double('client')
      expect(client_stub).to receive(:fetch_pull_request).with(pull_request).and_return(result)
      expect(RedmineGithub::GithubAPI::Graphql).to receive(:client_by_repository).with(repository).and_return(client_stub)
    end

    let(:result) do
      JSON.parse({
        data: {
          repository: {
            pull_request: {
              merged_at: merged_at,
              merge_state_status: mergeable_state
            }
          }
        },
        errors: errors
      }.to_json, object_class: OpenStruct)
    end
    let(:merged_at) { '2019-05-10 12:00:00'.to_datetime }
    let(:mergeable_state) { 'CLEAN' }
    let(:errors) { [] }
    it {
      expect { subject }.to(
        change do
          pull_request.reload.attributes.slice('merged_at', 'mergeable_state').symbolize_keys
        end.to(merged_at: merged_at, mergeable_state: mergeable_state)
      )
    }
  end
end
