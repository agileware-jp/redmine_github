# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'Issue Index Page' do
  let(:issue_with_pr) { create(:issue, subject: 'Issue with PR') }

  before do
    @issue_without_pr = create(:issue, subject: 'Issue without PR')
    PullRequest.create!(issue_id: issue_with_pr.id, url: 'https://github.com/octocat/spoon-fork/pulls/1')
    visit issues_path
  end

  specify 'User sees a link with has-pull-request class only if an issue has a PR' do
    expect(page).to have_selector "tr#issue-#{issue_with_pr.id}.issue.has-pull-request"
    expect(page).not_to have_selector "tr#issue-#{@issue_without_pr.id}.issue.has-pull-request"
  end

  specify 'User sees PR status on GitHub', :pending do
    expect(page).to have_content '[PR]My first PR'
  end
end
