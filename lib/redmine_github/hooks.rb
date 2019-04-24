# frozen_string_literal: true

module RedmineGithub
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_my_account, partial: 'hooks/redmine_github/view_my_account'
  end
end
