# frozen_string_literal: true

require File.expand_path('../../../../rails_helper', __dir__)

RSpec.describe RedmineGithub::Scm::Adapters::GithubAdapter do
  let(:scm) { RedmineGithub::Scm::Adapters::GithubAdapter.new(url, nil, login, token) }
  let(:url) { 'https://github.com/company/repo.git' }
  let(:login) { 'user' }
  let(:token) { '1234567890' }

  before :each do
    # will not try to create directory if it does not exists
    allow(Dir).to receive(:exist?) { true }
    allow(scm).to receive(:git_cmd) { nil }
  end

  describe '.repositories_root_path' do
    subject { scm.repositories_root_path }
    context 'directory exists' do
      it { is_expected.to eq Rails.root.join('repositories') }
    end
  end

  describe '.root_url' do
    subject { scm.root_url }
    context 'url is provided' do
      it { is_expected.to eq Rails.root.join('repositories', 'company-repo') }
    end

    context 'no url is provided' do
      let(:url) { nil }

      it { is_expected.to eq '' }
    end
  end

  describe '.url_with_token' do
    subject { scm.url_with_token }
    context 'no login and token are provided' do
      let(:login) { nil }
      let(:token) { nil }

      it { is_expected.to eq url }
    end

    context 'only login is provided' do
      let(:token) { nil }

      it { is_expected.to eq "https://#{login}@github.com/company/repo.git" }
    end

    context 'login and token are provided' do
      it { is_expected.to eq "https://#{login}:#{token}@github.com/company/repo.git" }
    end
  end

  describe '.fetch_remote' do
    subject { scm.fetch_remote }
    context 'root directory does not exists' do
      before do
        allow(Dir).to receive(:exist?) { false }
        expect(scm).to_not receive(:git_cmd)
      end

      it { is_expected.to be_nil }
    end

    context 'root directory exists' do
      let(:git_cmd_args) { %w[fetch origin +refs/heads/*:refs/heads/* +refs/tags/*:refs/tags/* --prune --prune-tags] }
      before { expect(scm).to receive(:git_cmd).with(git_cmd_args).and_return(nil) }
      it { is_expected.to be_nil }
    end
  end
end
