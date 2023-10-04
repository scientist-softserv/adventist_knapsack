# frozen_string_literal: true

RSpec.describe "The splash page", type: :feature, clean: true, multitenant: true do
  around do |example|
    default_host = Capybara.default_host
    Capybara.default_host = Capybara.app_host || "http://#{Account.admin_host}"
    example.run
    Capybara.default_host = default_host
  end

  it "shows the page, displaying the Adventist copyright" do
    visit '/'

    within 'footer' do
      expect(page).to have_link 'Administrator login'
    end

    expect(page).to have_content("© Adventist Digital Library 2022")
  end
end
