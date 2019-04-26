# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'Issue Index Page' do
  let(:issue_with_pr) { create(:issue, subject: 'Issue with PR') }

  before do
    @issue_without_pr = create(:issue, subject: 'Issue without PR')
    issue_with_pr.create_pull_request!(url: 'https://github.com/octocat/spoon-fork/pulls/1')
    visit issues_path
  end

  specify 'User sees a link with has-pull-request class only if an issue has a PR' do
    expect(page).to have_selector "tr#issue-#{issue_with_pr.id}.issue.has-pull-request"
    expect(page).not_to have_selector "tr#issue-#{@issue_without_pr.id}.issue.has-pull-request"
  end

  specify 'User sees PR status on GitHub only if an issue has a PR' do
    expect(page).to have_content '[PR]Issue with PR'
    expect(page).not_to have_content '[PR]Issue without PR'
  end
end
