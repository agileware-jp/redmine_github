# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    status            { Principal::STATUS_ACTIVE }
    language          { 'ja' }
    password          { 'password' }
    admin             { false }
    firstname         { 'First' }
    sequence(:lastname) { |n| "Last #{n}" }
    sequence(:mail)   { |n| "last#{n}@example.co.jp" }
    sequence(:login)  { |n| "last#{n}" }

    after(:build) do |user|
      user.pref.time_zone = 'Tokyo'
    end

    factory :admin_user do
      admin { true }
    end
  end
end
