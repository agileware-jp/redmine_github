module RedmineGithub::Scm::Adapters
  class GithubAdapter < Redmine::Scm::Adapters::GitAdapter
    def repositories_root_path
      Rails.root.join('repositories')
    end

    def root_url
      repositories_root_path.join(url.split(':').last.sub('.git', ''))
    end

    def bare_clone
      return if Dir.exists?(root_url)

      cmd_args = %W[clone --bare #{url} #{root_url}]
      git_cmd(cmd_args)
    end
  end
end
