# frozen_string_literal: true

module GithubRestApiHelper
  ROOT_PATH = File.expand_path('../github_rest_api', __dir__)

  def github_rest_api_mock(id:, method:, request:, response:)
    url = 'https://api.github.com/repos/company/repo/hooks'
    url = "#{url}/#{id}" if id
    stub_request(method, url)
      .with(body: request).to_return(status: 200, body: response)
  end

  def rest_api_json_for(id, variables = {})
    path = "#{ROOT_PATH}/#{id}.json"
    erb_path = "#{path}.erb"
    if File.exist?(erb_path)
      ERB.new(File.read(erb_path).strip).result(binding)
    else
      File.read(path).strip
    end
  end
end

RSpec.configure do |config|
  config.prepend GithubRestApiHelper
end
