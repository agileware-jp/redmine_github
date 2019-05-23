# frozen_string_literal: true

require 'uri'

module RedmineGithub::Scm::Adapters
  class GithubAdapter < Redmine::Scm::Adapters::GitAdapter
    def initialize(url, root_url, access_token, webhook_secret, path_encoding = nil)
      @url = url
      @access_token = access_token
      @webhook_secret = webhook_secret
      @root_url = root_url.blank? ? retrieve_root_url : root_url
      @path_encoding = path_encoding.blank? ? 'UTF-8' : path_encoding
    end

    def repositories_root_path
      repo_path = Rails.root.join('repositories')

      FileUtils.mkdir_p(repo_path) unless Dir.exist?(repo_path)

      repo_path
    end

    def root_url
      return '' unless url

      root_path = url.split('/')[-2..-1].join('-').sub('.git', '')
      repositories_root_path.join(root_path)
    end

    def url_with_token
      parsed_url = URI.parse(url)

      # uri = url or "#{login}@url"
      parsed_url.user = ERB::Util.url_encode(@access_token) if @access_token.present?
      parsed_url.to_s
    end

    def bare_clone
      return if Dir.exist?(root_url)

      cmd_args = %W[clone --bare #{url_with_token} #{root_url}]
      git_cmd(cmd_args)
    end

    def update_remote_url
      cmd_args = %W[remote set-url origin #{url_with_token}]

      git_cmd(cmd_args)
    end

    def fetch_remote
      return unless Dir.exist?(root_url)

      ENV['GIT_TERMINAL_PROMPT'] = '0'
      cmd_args = %w[fetch origin]
      cmd_args += %w[+refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/*]
      cmd_args += %w[--prune]
      git_cmd(cmd_args)
    end
  end
end
