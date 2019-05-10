# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'POST /redmine_github/webhook/' do
  describe 'handle' do
    shared_examples 'call handler with correct arguments and return http ok' do
      it {
        headers = { 'x-github-event' => event, content_type: :json }
        expect(RedmineGithub::PullRequestHandler).to receive(:handle).with(event, be_an_instance_of(ActionController::Parameters))
        post redmine_github_webhook_path(format: :json), params: params, headers: headers
        expect(response).to have_http_status(:ok)
      }
    end

    shared_examples 'ignored and return http ok' do
      it {
        headers = { 'x-github-event' => event, content_type: :json }
        expect(RedmineGithub::PullRequestHandler).to_not receive(:handle)
        post redmine_github_webhook_path(format: :json), params: params, headers: headers
        expect(response).to have_http_status(:ok)
      }
    end

    let(:params) { {} }

    context 'event type with pull_request' do
      let(:event) { 'pull_request' }
      include_examples 'call handler with correct arguments and return http ok'
    end

    context 'event type with pull_request_review' do
      let(:event) { 'pull_request_review' }
      include_examples 'call handler with correct arguments and return http ok'
    end

    context 'event type with push' do
      let(:event) { 'push' }
      include_examples 'call handler with correct arguments and return http ok'
    end

    context 'event type with status' do
      let(:event) { 'status' }
      include_examples 'call handler with correct arguments and return http ok'
    end

    context 'event type with unknown' do
      let(:event) { 'unknown' }
      include_examples 'ignored and return http ok'
    end
  end
end
