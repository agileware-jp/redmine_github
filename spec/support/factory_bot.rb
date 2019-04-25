# frozen_string_literal: true

FactoryBot.definition_file_paths = [File.join(__dir__, '../factories')]

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  FactoryBot.find_definitions
end
