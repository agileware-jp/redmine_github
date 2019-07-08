# frozen_string_literal: true

module RedmineGithub
  module GithubAPI
    module Rest
      class Client
        def initialize(uri, access_token)
          @uri = URI.parse(uri)
          @access_token = access_token
        end

        def get
          execute(:get)
        end

        def post(payload)
          execute(:post, payload)
        end

        def patch(payload)
          execute(:patch, payload)
        end

        def delete
          execute(:delete)
        end

        private

        attr_reader :uri, :access_token

        def connection
          Net::HTTP.new(uri.host, uri.port).tap do |client|
            client.use_ssl = uri.scheme == 'https'
          end
        end

        def execute(method, payload = '')
          klass = Net::HTTP.const_get(method.to_s.classify)
          request = klass.new(uri.request_uri)
          request['Accept'] = 'application/json'
          request['Content-Type'] = 'application/json'
          request['Authorization'] = "token #{access_token}"
          Rails.logger.debug("> #{method} #{uri} - #{payload}")
          request.body = payload
          response = connection.request(request)
          Rails.logger.debug("< #{response.code} #{response.message} #{response.body}")
          begin
            json = response.body.present? ? JSON.parse(response.body) : nil
            raise Error, response if response.code.to_i >= 400

            json
          rescue StandardError
            raise Error, response
          end
        end
      end
    end
  end
end
