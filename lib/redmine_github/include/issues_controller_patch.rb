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
              super + link_to(
                '',
                item.pull_request.url,
                class: "icon-pr #{item.pull_request.state}"
              )
            else
              super
            end
          end
        end)
      end
    end
  end
end
