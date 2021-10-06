# frozen_string_literal: true

module LoginHelpers
  module Controller
    def login_as(user)
      @request.session[:user_id] = user.id
    end
  end

  module Request
    def login_as(user)
      post signin_path username: user.login, password: user.password
      expect(user.login).to eq User.find(session[:user_id]).login
    end
  end

  module Feature
    def login_as(user, password = 'password')
      # Log in
      visit signin_path
      fill_in('username', with: user.login)
      fill_in('password', with: password)
      click_button ''
    end
  end
end

RSpec.configure do |config|
  config.include LoginHelpers::Controller, type: :controller
  config.include LoginHelpers::Request, type: :request
  config.include LoginHelpers::Feature, type: :feature
end
