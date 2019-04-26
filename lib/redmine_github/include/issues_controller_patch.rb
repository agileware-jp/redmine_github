# frozen_string_literal: true

module RedmineGithub
  module Include
    module IssuesControllerPatch
      extend ActiveSupport::Concern

      included do
        helper(Module.new do
          def column_value(column, item, value)
            # TODO: fix N+1
            if column.name == :subject && item.try(:pull_request).present?
              link_to('&nbsp;'.html_safe, item.pull_request.url, class: 'icon icon-pr-opened') + super
            else
              super
            end
          end
        end)
      end
    end
  end
end
