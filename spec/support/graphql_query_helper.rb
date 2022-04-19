# frozen_string_literal: true

module GraphqlQueryHelper
  ROOT_PATH = File.expand_path('../graphql_queries', __dir__)

  def graphql_mock(request:, response:)
    stub_request(:post, 'https://api.github.com/graphql')
      .with(body: request).to_return(status: 200, body: response)
  end

  def graphql_json_for(id, variables = {})
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
  config.prepend GraphqlQueryHelper
end
