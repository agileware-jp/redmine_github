module CompatibleVerbs
  def post(path, env: {}, headers: {}, params: nil)
    super(path, params, env.merge(headers))
  end
end

RSpec.configure do |config|
  config.prepend CompatibleVerbs, type: :request if Rails::VERSION::MAJOR < 5
end
