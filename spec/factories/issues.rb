# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:subject) { |n| "Issue#{n}" }
    project
    tracker { project.trackers.first }
    association(:author, factory: :user)
    association(:priority, factory: :issue_priority)
    association(:status, factory: :issue_status)

    trait :with_pull_request do
      transient do
        sequence(:pull_request_url) { |n| "http://example.com/pull_requests/#{n}" }
      end

      after(:create) do |issue, evaluator|
        create :pull_request, issue: issue, url: evaluator.pull_request_url
      end
    end
  end
end
