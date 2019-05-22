# frozen_string_literal: true

class GithubCredential < ActiveRecord::Base
  include Redmine::Ciphering

  belongs_to :repository, class_name: 'Repository::Github'

  def webhook_secret=(secret)
    write_ciphered_attribute(:webhook_secret, secret)
  end

  def webhook_secret
    read_ciphered_attribute(:webhook_secret)
  end
end
