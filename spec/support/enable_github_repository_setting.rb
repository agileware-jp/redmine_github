RSpec.configure do |config|
  config.before(:suite) do
    Setting.enabled_scm = Setting.enabled_scm + ['Github'] if Setting.enabled_scm.exclude?('Github')
  end
end
