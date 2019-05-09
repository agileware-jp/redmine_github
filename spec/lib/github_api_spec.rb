# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe RedmineGithub::GithubAPI do
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

  let(:repository) { create :github_repository, url: 'https://github.com/agileware-jp/sample.git' }
  describe '#fetch_pull_request' do
    subject { described_class.client_by_repository(repository).fetch_pull_request(pull_request) }

    let(:pull_request) { create :pull_request, url: 'https://github.com/agileware-jp/sample/pull/1' }
    let(:merged_at) { Time.current.to_s }
    let(:mergeable_state) { 'CLEAN' }

    before do
      request = graphpl_json_for(:fetch_pr_request,
                                 repository_id: repository.id,
                                 pull_request_number: pull_request.number,
                                 repo_owner: pull_request.repo_owner,
                                 repo_name: pull_request.repo_name)
      response = graphpl_json_for(:fetch_pr_response,
                                  merged_at: merged_at,
                                  mergeable_state: mergeable_state)
      graphql_mock(request: request, response: response)
    end

    it { expect(subject.data.repository.pull_request.merged_at).to eq(merged_at) }
    it { expect(subject.data.repository.pull_request.merge_state_status).to eq(mergeable_state) }
  end
end
