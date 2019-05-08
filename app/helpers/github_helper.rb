# frozen_string_literal: true

module GithubHelper
  def github_field_tags(form, repository)
    # FIXME: 汚い
    # TODO: label
    content_tag('p', form.text_field(
      :url, label: l(:field_url),
            size: 60, required: true,
            disabled: !repository.safe_attribute?('url')) +
    scm_path_info_tag(repository)) +
    content_tag('p', form.text_field(:login, :size => 30)) +
    content_tag('p', form.password_field(
      :password, size: 30, name: 'ignore',
      value: ((repository.new_record? || repository.password.blank?) ? '' : ('x'*15)),
      onfocus: "this.value=''; this.name='repository[password]';",
      onchange: "this.name='repository[password]';")) +
    scm_path_encoding_tag(form, repository) +
    content_tag('p', form.check_box(
      :report_last_commit, label: l(:label_git_report_last_commit)
    ))
  end
end
