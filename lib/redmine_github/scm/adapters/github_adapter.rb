# frozen_string_literal: true

module RedmineGithub::Scm::Adapters
  class GithubAdapter < Redmine::Scm::Adapters::GitAdapter
    def repositories_root_path
      Rails.root.join('repositories')
    end

    def root_url
      repositories_root_path.join(url.split(':').last.sub('.git', ''))
    end

    def bare_clone
      return if Dir.exist?(root_url)

      configure_ssh_key do
        cmd_args = %W[clone --bare #{url} #{root_url}]
        git_cmd(cmd_args)
      end
    end

    def configure_ssh_key
      if User.current.ssh_key.present? && User.current.ssh_key.private_key.present?
        Tempfile.create('id_rsa') do |f|
          f.write User.current.ssh_key.private_key

          shellout("git config core.sshCommand \"ssh -i #{f.path} -F /dev/null\"")

          yield
        end
      else
        yield
      end
    end
  end
end
