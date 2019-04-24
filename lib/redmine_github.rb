# frozen_string_literal: true

module RedmineGithub
  def self.rails5_or_later?
    Rails::VERSION::MAJOR >= 5
  end
end
