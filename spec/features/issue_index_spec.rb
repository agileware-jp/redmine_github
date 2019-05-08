# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'Issue Index Page' do
  let!(:issue_with_pr) { create(:issue, :with_pull_request, subject: 'Issue with PR') }
  let!(:issue_without_pr) { create(:issue, subject: 'Issue without PR') }

  before do
    visit issues_path
  end

  specify 'User sees a link with has-pull-request class only if an issue has a PR' do
    expect(page).to have_selector "tr#issue-#{issue_with_pr.id}.issue.has-pull-request"
    expect(page).not_to have_selector "tr#issue-#{issue_without_pr.id}.issue.has-pull-request"
  end

  specify 'User sees PR status on GitHub only if an issue has a PR' do
    within 'tr.issue.has-pull-request > td.subject' do
      expect(page).to have_selector 'a', count: 2
      expect(page).to have_selector %(a[href="#{issue_with_pr.pull_request.url}"])
    end
    within 'tr.issue:not(.has-pull-request) > td.subject' do
      expect(page).to have_selector 'a', count: 1
    end
  end
end
