require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'POST /redmine_github/webhook/' do
  before do
    post redmine_github_webhook_path(format: :json)
  end

  it {
    expect(response).to have_http_status(:ok)
  }
end
