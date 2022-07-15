# frozen_string_literal: true

require File.expand_path('../../rails_helper', __dir__)

RSpec.describe RepositoriesController, type: :controller do
  render_views

  let(:project) { create(:project) }
  let(:admin) { create(:admin_user) }

  before do
    login_as(admin)
  end

  describe '#create' do
    subject(:call) do
      fixed_params = Rails::VERSION::MAJOR < 5 ? params : { params: params }
      post(:create, **fixed_params)
    end

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

    around do |example|
      Repository::Github.skip_callback(:create, :after, :bare_clone)
      begin
        example.run
      ensure
        Repository::Github.set_callback(:create, :after, :bare_clone)
      end
    end

    context 'create repository' do
      it 'should send webhooks API request' do
        expect_any_instance_of(RedmineGithub::GithubApi::Rest::Webhook).to receive(:create)
        expect(call).to redirect_to(settings_project_path(project, tab: :repositories))
      end
    end

    context 'when failed to create webhook on GitHub.com' do
      it 'should not create Repository record' do
        unauthorized_response = Net::HTTPResponse.new('1.1', '401', 'Unauthorized')
        allow_any_instance_of(RedmineGithub::GithubApi::Rest::Client).to(
          receive(:post).
            and_raise(RedmineGithub::GithubApi::Rest::Error, unauthorized_response)
        )
        expect { call }.not_to(change(Repository, :count))
        expect(response).to have_http_status(:success)
      end
    end
  end
end
