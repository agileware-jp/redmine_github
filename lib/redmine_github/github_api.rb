# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

module RedmineGithub
  module GithubAPI
    END_POINT = 'https://api.github.com/graphql'

    def self.client_by_repository(repository)
      @class_by_repository ||= {}
      @class_by_repository[repository.id] ||= build_client_class(repository)
    end

    def self.build_client_class(repository)
      mod = Module.new
      self.const_set("Repository#{repository.id}Client", mod)
      mod.class_eval do
        mod.const_set :REPOSITORY, repository
        http = GraphQL::Client::HTTP.new(END_POINT) do
          @@__secret_token__ = repository.password

          def headers(_context)
            {
              'Authorization' => "Bearer #{@@__secret_token__}",
              'Accept' => 'application/vnd.github.merge-info-preview+json'
            }
          end
        end
        schema = GraphQL::Client.load_schema(http)
        client = GraphQL::Client.new(schema: schema, execute: http)
        mod.const_set :CLIENT, client
        query = client.parse <<-'GRAPHQL'.strip_heredoc
          query($number: Int!, $repo_owner: String!, $repo_name: String!) {
            repository(owner: $repo_owner, name: $repo_name) {
              pullRequest(number: $number) {
                number
                title
                state
                mergeable
                mergeStateStatus
              }
            }
          }
        GRAPHQL
        mod.const_set(:GET_PR_QUERY, query)

        module_function

        def fetch_pull_request(pull_request)
          self::CLIENT.query(
            self::GET_PR_QUERY,
            variables: {
              number: pull_request.number.to_i,
              repo_owner: pull_request.repo_owner,
              repo_name: pull_request.repo_name
            }
          )
        end
      end
      mod
    end
  end
end
