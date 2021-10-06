# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../rails_helper')

RSpec.feature 'PluginSettings', type: :feature do
  feature 'webhook will use hostname' do
    given(:admin) { create(:admin_user) }

    context 'When visit plugin settings page' do
      before do
        login_as(admin)
        visit plugin_settings_path(:redmine_github)
      end

      scenario 'user visit Plugin Settings page' do
        expect(page).to have_text 'Webhookリクエスト'
      end
    end
  end
end
