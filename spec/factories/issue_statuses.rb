# frozen_string_literal: true

FactoryBot.define do
  factory :issue_status do
    sequence(:name) { |n| "IssueStatus#{n}" }
  end
end
