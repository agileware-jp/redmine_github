# frozen_string_literal: true

module CompatibleVerbs
  def post(path, env: {}, headers: {}, params: nil)
    super(path, params, env.merge(headers))
  end
end

RSpec.configure do |config|
  config.before :each do
    if User.private_instance_methods.grep(:deliver_security_notification).present?
      allow_any_instance_of(User).to receive(:deliver_security_notification).and_return(nil)
    end
  end

  config.prepend CompatibleVerbs, type: :request if Rails::VERSION::MAJOR < 5
end
