# frozen_string_literal: true

require File.expand_path('../../../../rails_helper', __dir__)

RSpec.describe RedmineGithub::Scm::Adapters::GithubAdapter do
  subject { RedmineGithub::Scm::Adapters::GithubAdapter.new(url, nil, login, token) }

  let(:url) { 'https://github.com/company/repo.git' }
  let(:login) { 'user' }
  let(:token) { '1234567890' }

  before do
    # will not try to create directory if it does not exists
    allow(Dir).to receive(:exists?) { true }
  end

  describe '.repositories_root_path' do
    context 'directory exists' do
      it { expect(subject.repositories_root_path).to eq Rails.root.join('repositories') }
    end
  end

  describe '.root_url' do
    context 'url is provided' do
      it { expect(subject.root_url).to eq Rails.root.join('repositories', 'company-repo') }
    end

    context 'no url is provided' do
      let(:url) { nil }

      it { expect(subject.root_url).to eq '' }
    end
  end

  describe '.url_with_token' do
    context 'no login and token are provided' do
      let(:login) { nil }
      let(:token) { nil }

      it { expect(subject.url_with_token).to eq url }
    end

    context 'only login is provided' do
      let(:token) { nil }

      it { expect(subject.url_with_token).to eq "https://#{login}@github.com/company/repo.git" }
    end

    context 'login and token are provided' do
      it { expect(subject.url_with_token).to eq "https://#{login}:#{token}@github.com/company/repo.git" }
    end
  end
end
