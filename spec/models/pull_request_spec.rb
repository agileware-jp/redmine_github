# frozen_string_literal: true

require File.expand_path('../rails_helper', __dir__)

RSpec.describe PullRequest do
  describe 'validation URL' do
    let (:pull_request) { PullRequest.new }

    it do
      pull_request.valid?
      expect(pull_request.errors.full_messages).to include 'URL cannot be blank'
    end
  end
end
