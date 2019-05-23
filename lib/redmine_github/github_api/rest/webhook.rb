# frozen_string_literal: true

module RedmineGithub
  module GithubAPI
    module Rest
      class Webhook
        delegate :owner, :repo, :access_token, to: :repository

        def initialize(repository)
          @repository = repository
        end

        def list
          Client.new(base_url, access_token).get
        end

        def create(payload)
          Client.new(base_url, access_token).post(payload)
        end

        def show(id)
          Client.new(base_url(id), access_token).get
        end

        def update(id, payload)
          Client.new(base_url(id), access_token).patch(payload)
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
