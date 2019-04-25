# frozen_string_literal: true

class PullRequest < ActiveRecord::Base
  validates :url, presence: true
end
