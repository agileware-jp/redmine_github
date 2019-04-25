# frozen_string_literal: true

FactoryBot.define do
  factory :issue_priority do
    sequence(:name) { |n| "IssuePriority#{n}" }
  end
end
