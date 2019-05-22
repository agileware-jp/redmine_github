# frozen_string_literal: true

class CreateGithubCredentials < RedmineGithub::Migration::MIGRATION_CLASS
  def change
    create_table :github_credentials do |t|
      t.references :repository
      t.text :webhook_secret

      t.timestamps null: false
    end
  end
end
