class CreatePullRequests < RedmineGithub::Migration::MIGRATION_CLASS
  def change
    create_table :pull_requests do |t|
      t.belongs_to :issue, index: true, foreign_key: true
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
