module RedmineGithub
  Reloader = if RedmineGithub.rails5_or_later?
               ActiveSupport::Realoader
             else
               ActionDispatch::Reloader
             end
end
