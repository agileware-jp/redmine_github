# frozen_string_literal: true

FactoryBot.define do
  factory :issue do
    sequence(:subject) { |n| "Issue#{n}" }
    project
    tracker { project.trackers.first }
    association(:author, factory: :user)
    association(:priority, factory: :issue_priority)
    association(:status, factory: :issue_status)
  end
end
