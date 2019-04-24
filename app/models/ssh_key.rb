# frozen_string_literal: true

class SshKey < ActiveRecord::Base
  belongs_to :user
end
