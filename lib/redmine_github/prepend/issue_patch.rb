# frozen_string_literal: true

module RedmineGithub
  module Prepend
    module IssuePatch
      def css_classes(_user = User.current)
        if pull_request.present?
          super + ' has-pull-request'
        else
          super
        end
      end
    end
  end
end
