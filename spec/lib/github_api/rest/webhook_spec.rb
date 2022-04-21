# frozen_string_literal: true

require File.expand_path('../../../rails_helper', __dir__)

RSpec.describe RedmineGithub::GithubApi::Rest::Webhook do
  GITHUB_API_URL = 'https://api.github.com/repos/company/repo/hooks'

  let(:project) { create :project }
  let(:webhook_url) { "https://host.site/project/#{project.id}/hook" }
  let(:events) { %w[pull_request pull_request_review push status] }
  let(:repository) { create :github_repository, url: 'https://github.com/company/repo.git' }
  let(:new_webhook) { RedmineGithub::GithubApi::Rest::Webhook.new(repository) }
  let(:params) do
    {
      config: {
        url: webhook_url,
        content_type: 'json',
        secret: repository.webhook_secret
      },
      events: events,
      active: true
    }
  end
  let(:update_params) do
    {
      add_events: %w[commit_comment],
      active: true
    }
  end

  describe '#list' do
    before do
      response = rest_api_json_for(:list_webhooks_response,
                                   webhook_id: project.id,
                                   webhook_url: webhook_url)
      github_rest_api_mock(id: nil, method: :get, request: nil, response: response)
    end
    subject { JSON.parse(new_webhook.list.to_json, symbolize_names: true) }

    it { expect(subject.count).to eq 2 }
    it { expect(subject.last[:config][:url]).to eq webhook_url }
    it { expect(subject.last[:url]).to eq "#{GITHUB_API_URL}/#{project.id}" }
  end

  describe '#create' do
    before do
      request = rest_api_json_for(:create_webhook_request,
                                  webhook_url: webhook_url,
                                  webhook_secret: repository.webhook_secret)
      response = rest_api_json_for(:create_webhook_response,
                                   webhook_id: project.id,
                                   webhook_url: webhook_url)
      github_rest_api_mock(id: nil, method: :post, request: request, response: response)
    end
    subject { JSON.parse(new_webhook.create(params).to_json, symbolize_names: true) }

    it { expect(subject[:config][:url]).to eq webhook_url }
    it { expect(subject[:url]).to eq "#{GITHUB_API_URL}/#{project.id}" }
  end

  describe '#show' do
    before do
      response = rest_api_json_for(:show_webhook_response,
                                   webhook_id: project.id,
                                   webhook_url: webhook_url)
      github_rest_api_mock(id: project.id, method: :get, request: nil, response: response)
    end
    subject { JSON.parse(new_webhook.show(project.id).to_json, symbolize_names: true) }

    it { expect(subject[:id]).to eq project.id }
    it { expect(subject[:config][:url]).to eq webhook_url }
    it { expect(subject[:url]).to eq "#{GITHUB_API_URL}/#{project.id}" }
  end

  describe '#update' do
    before do
      response = rest_api_json_for(:update_webhook_response,
                                   webhook_id: project.id,
                                   webhook_url: webhook_url)
      github_rest_api_mock(id: project.id, method: :patch, request: update_params.to_json, response: response)
    end
    subject { JSON.parse(new_webhook.update(project.id, update_params).to_json, symbolize_names: true) }

    it { expect(subject[:events]).to eq %w[commit_comment] + events }
  end
end
