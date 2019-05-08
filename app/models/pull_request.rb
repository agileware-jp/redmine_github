# frozen_string_literal: true

class PullRequest < ActiveRecord::Base
  belongs_to :issue
  validates :url, presence: true
end
