# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:mail) { |n| "user_#{n}@example.com" }
    sequence(:login) { |n| "user_#{n}" }
    firstname { 'first' }
    lastname { 'last' }
  end
end
