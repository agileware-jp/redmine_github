# frozen_string_literal: true

class AddMergeableStateToPullRequests < RedmineGithub::Migration::MIGRATION_CLASS
  def change
    add_column :pull_requests, :mergeable_state, :string
  end
end
