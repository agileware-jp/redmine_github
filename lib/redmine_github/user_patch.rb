# frozen_string_literal: true

module RedmineGithub
  module UserPatch
    extend ActiveSupport::Concern

    included do
      has_one :ssh_key, dependent: :destroy

      accepts_nested_attributes_for :ssh_key, allow_destroy: true

      safe_attributes :ssh_key_attributes if respond_to?(:safe_attributes)
    end
  end
end
