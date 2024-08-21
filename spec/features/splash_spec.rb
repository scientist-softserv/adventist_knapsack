# frozen_string_literal: true

RSpec.describe "The splash page", type: :feature, clean: true, multitenant: true do
  around do |example|
    default_host = Capybara.default_host
    Capybara.default_host = Capybara.app_host || "http://#{Account.admin_host}"
    example.run
    Capybara.default_host = default_host
  end

  # TODO: This spec is failing due to a change in the styling of the splash page as requested by the client.
  # The current splash page has the base Hyku styling rather than ADL branding. If the client is happy with the
  # base Hyku splash page, this spec can be removed. If the client wants the ADL branding on the splash page,
  # this spec will need to be updated.
  xit "shows the page, displaying the Adventist copyright" do
    visit '/'
    within 'footer' do
      expect(page).to have_link 'Administrator login'
    end
    expect(page).to have_content("© Adventist Digital Library 2022")
  end
end
