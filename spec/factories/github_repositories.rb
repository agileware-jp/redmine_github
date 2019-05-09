# frozen_string_literal: true

FactoryBot.define do
  factory :github_repository, class: ::Repository::Github do
    type { 'Repository::Github' }
    project
    sequence(:url) { |n| "https://github.com/agileware-jp/sample#{n}.git" }
    sequence(:login) { |n| "user #{n}" }
    password { 'password' }
    sequence(:identifier) { |n| "github-identifier-#{n}" }
  end
end
