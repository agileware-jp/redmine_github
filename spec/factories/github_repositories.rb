# frozen_string_literal: true

FactoryBot.define do
  factory :github_repository, class: ::Repository::Github do
    type { 'Repository::Github' }
    project
    sequence(:url) { |n| "https://github.com/company/repo#{n}.git" }
    access_token { '0x123456789' }
    webhook_secret { 'secret' }
    sequence(:identifier) { |n| "github-identifier-#{n}" }

    before(:create) { Repository::Github.skip_callback(:create, :after, :bare_clone) }
    after(:create) { Repository::Github.set_callback(:create, :after, :bare_clone) }
  end
end
