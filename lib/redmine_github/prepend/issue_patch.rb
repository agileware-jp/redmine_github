# frozen_string_literal: true

module RedmineGithub
  module Prepend
    module IssuePatch
      def css_classes(_user = User.current)
        if PullRequest.exists?(issue_id: id)
          super + ' has-pull-request'
        else
          super
        end
      end
    end
  end
end
