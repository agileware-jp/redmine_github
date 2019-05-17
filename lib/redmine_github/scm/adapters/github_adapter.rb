# frozen_string_literal: true

require 'uri'

module RedmineGithub::Scm::Adapters
  class GithubAdapter < Redmine::Scm::Adapters::GitAdapter
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

      # uri = url or "#{login}@url" or "#{login}:#{password}@url"
      parsed_url.user = ERB::Util.url_encode(@login) if @login.present?
      parsed_url.password = ERB::Util.url_encode(@password) if @password.present?
      parsed_url.to_s
    end

    def bare_clone
      return if Dir.exist?(root_url)

      cmd_args = %W[clone --bare #{url_with_token} #{root_url}]
      git_cmd(cmd_args)
    end

    def fetch_remote
      return unless Dir.exist?(root_url)

      cmd_args = %w[fetch origin]
      cmd_args += %w[+refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/*]
      cmd_args += %w[--prune --prune-tags]
      git_cmd(cmd_args)
    end
  end
end
