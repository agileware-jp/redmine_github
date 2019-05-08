# frozen_string_literal: true

FactoryBot.define do
  factory :pull_request do
    issue
    sequence(:url) { |n| "https://example.com/pull_requests/#{n}" }
  end
end
