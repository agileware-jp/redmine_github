class DropSshKeys < RedmineGithub::Migration::MIGRATION_CLASS
  # Drops the table on applying and creates the table on rollbacking.
  def change
    drop :ssh_keys do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.text :public_key
      t.text :private_key

      t.timestamps null: false
    end
  end
end
