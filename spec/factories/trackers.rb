# frozen_string_literal: true

FactoryBot.define do
  factory :tracker do
    sequence(:name) { |n| "Tracker#{n}" }
    association(:default_status, factory: :issue_status)
  end
end
