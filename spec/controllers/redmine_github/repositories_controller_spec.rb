# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RepositoriesController, type: :controller do
  render_views

  let(:project) { create(:project) }

  before do
    allow_any_instance_of(RepositoriesController).to receive(:authorize) { true }
    # interupt Github webhook API POST requests
    allow_any_instance_of(RedmineGithub::GithubAPI::Rest::Client).to receive(:post) { nil }
  end

  context 'create repository' do
    let(:params) do
      {
        project_id: project.id,
        repository_scm: 'Github',
        repository: {
          url: 'https://github.com/company/repo.git',
          access_token: '0x123456789',
          webhook_secret: 'secret'
        }
      }
    end

    before do
      expect_any_instance_of(RedmineGithub::GithubAPI::Rest::Webhook).to receive(:create)
    end

    it 'should send webhooks API request' do
      Repository::Github.skip_callback(:create, :after, :bare_clone)
      expect(post :create, params: params).to redirect_to(settings_project_path(project, tab: :repositories))
      Repository::Github.set_callback(:create, :after, :bare_clone)
    end
  end
end
