# frozen_string_literal: true

module GithubHelper
  def github_field_tags(form, repository)
    render partial: 'redmine_github/github_fields', locals: { form: form, repository: repository }
  end
end
