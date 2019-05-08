# frozen_string_literal: true

class AddMergedAtToPullRequests < RedmineGithub::Migration::MIGRATION_CLASS
  def change
    add_column :pull_requests, :merged_at, :datetime
  end
end
