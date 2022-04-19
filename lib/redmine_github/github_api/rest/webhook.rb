# frozen_string_literal: true

module RedmineGithub
  module GithubApi
    module Rest
      class Webhook
        delegate :owner, :repo, :access_token, to: :repository

        def initialize(repository)
          @repository = repository
        end

        def list
          Client.new(base_url, access_token).get
        end

        def create(params)
          Client.new(base_url, access_token).post(params.to_json)
        end

        def show(id)
          Client.new(base_url(id), access_token).get
        end

        def update(id, params)
          Client.new(base_url(id), access_token).patch(params.to_json)
        end

        def destroy(id)
          Client.new(base_url(id), access_token).delete
        end

        private

        attr_reader :repository

        def base_url(id = nil)
          url = "#{END_POINT}/repos/#{owner}/#{repo}/hooks"
          url = "#{url}/#{id}" if id
          url
        end
      end
    end
  end
end
