# frozen_string_literal: true

module RedmineGithub
  module GithubApi
    module Rest
      class Error < StandardError
        attr_reader :response

        def initialize(response)
          @response = response
          super("#{response.code} #{response.message}")
        end
      end
    end
  end
end
