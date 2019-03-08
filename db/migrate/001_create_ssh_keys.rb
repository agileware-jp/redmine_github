class CreateSshKeys < RedmineGithub::Migration::MIGRATION_CLASS
  def change
    create_table :ssh_keys do |t|
      t.belongs_to :user, index: true, foreign_key: true

      t.text :public_key
      t.text :private_key

      t.timestamps null: false
    end
  end
end
