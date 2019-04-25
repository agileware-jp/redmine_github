# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe 'Issue Index Page' do
  let(:issue) { create(:issue, subject: 'My first PR') }

  specify 'User sees PR status on GitHub' do
    visit issues_path

    expect(page).to have_content '[PR]My first PR'
  end
end
