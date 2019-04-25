# frozen_string_literal: true

module RedmineGithub
  Reloader = if RedmineGithub.rails5_or_later?
               ActiveSupport::Reloader
             else
               ActionDispatch::Reloader
             end
end
