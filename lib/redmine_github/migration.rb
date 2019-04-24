# frozen_string_literal: true

module RedmineGithub
  module Migration
    MIGRATION_CLASS = if RedmineGithub.rails5_or_later?
                        ActiveRecord::Migration[4.2]
                      else
                        ActiveRecord::Migration
                      end
  end
end
