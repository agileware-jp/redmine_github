module LoginHelpers
  # Yields the block with user as the current user
  def with_current_user(user)
    saved_user = User.current
    User.current = user
    yield
  ensure
    User.current = saved_user
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

  module Controller
    def login_as(user)
      @request.session[:user_id] = user.id
    end
  end
end

RSpec.configure do |config|
  config.include LoginHelpers
  config.include LoginHelpers::Feature, type: :feature
  config.include LoginHelpers::Controller, type: :controller
end
