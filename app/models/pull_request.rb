# frozen_string_literal: true

class PullRequest < ActiveRecord::Base
  belongs_to :issue
  validates :url, presence: true

  def state
    if merged_at.present?
      :merged
    else
      :opened
    end
  end
end
