# frozen_string_literal: true

module RedmineGithub
  module Include
    module IssuePatch
      extend ActiveSupport::Concern

      included do
        has_one :pull_request, dependent: :destroy
      end
    end
  end
end
