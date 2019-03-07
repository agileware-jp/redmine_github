module GitHubHelper
  def git_hub_field_tags(form, repository)
    # FIXME: 汚い
    content_tag('p', form.text_field(
                :url, :label => l(:field_path_to_repository),
                :size => 60, :required => true,
                :disabled => !repository.safe_attribute?('url')
                         ) + 
                      scm_path_info_tag(repository)) +
    scm_path_encoding_tag(form, repository) +
    content_tag('p', form.check_box(
                :report_last_commit,
                :label => l(:label_git_report_last_commit)
                ))  
  end 
end
