# frozen_string_literal: true

class DropSshKeys < RedmineGithub::Migration::MIGRATION_CLASS
  def up
    drop_table(:ssh_keys, if_exists: true)
  end
end