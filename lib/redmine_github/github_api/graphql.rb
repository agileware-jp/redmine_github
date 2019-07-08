# frozen_string_literal: true

require 'graphql/client'
require 'graphql/client/http'

module RedmineGithub
  module GithubAPI
    module Graphql
      END_POINT = 'https://api.github.com/graphql'

      FETCH_PR_QUERY_BASE = <<-'GRAPHQL'.strip_heredoc
        query($number: Int!, $repo_owner: String!, $repo_name: String!) {
          repository(owner: $repo_owner, name: $repo_name) {
            pullRequest(number: $number) {
              number
              title
              state
              mergeable
              mergedAt
              mergeStateStatus
            }
          }
        }
      GRAPHQL

      module ClientMethods
        def fetch_pull_request(pull_request)
          self::CLIENT.query(
            self::FETCH_PR_QUERY,
            variables: {
              number: pull_request.number.to_i,
              repo_owner: pull_request.repo_owner,
              repo_name: pull_request.repo_name
            }
          )
        end
      end

      module_function

      def client_by_repository(repository)
        @module_by_repository ||= {}
        @module_by_repository[repository.id] ||= build_client_module(repository)
      end

      def build_client_module(repository)
        # A repository has personal token and graphql schema may differcent from each repositories.
        # But graphql query must be constant variable, then create client module for each repositories.
        mod = Module.new
        const_set("Repository#{repository.id}Client", mod)
        mod.module_eval do
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
          mod.const_set(:FETCH_PR_QUERY, client.parse(FETCH_PR_QUERY_BASE))
        end
        mod.extend(ClientMethods)
        mod
      end
    end
  end
end
