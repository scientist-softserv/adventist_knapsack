# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "View Range Limit Search Results", type: :feature, clean: true, js: false, multitentant: true do
  let(:account) { create(:account) }
  let(:tenant_user_attributes) { attributes_for(:user) }

  let(:tenant_user) { create(:user) }

  let(:aligator) do
    {
      system_create_dtsi: "2021-06-08T22:01:36Z",
      system_modified_dtsi: "2021-06-08T22:19:40Z",
      has_model_ssim: ["GenericWork"],
      id: "111",
      accessControl_ssim: ["f331c617-842c-4e95-a5f1-9be171458878"],
      hasRelatedMediaFragment_ssim: ["5766d215-ac1c-440a-88cc-48854c30ae77"],
      hasRelatedImage_ssim: ["5766d215-ac1c-440a-88cc-48854c30ae77"],
      depositor_ssim: [tenant_user.email.to_s],
      depositor_tesim: [tenant_user.email.to_s],
      title_tesim: ["Aligator Work"],
      date_uploaded_dtsi: "2021-06-08T22:01:34Z",
      date_modified_dtsi: "2021-06-08T22:19:40Z",
      isPartOf_ssim: ["admin_set/default"],
      date_created_tesim: ["2021-04-01"],
      creator_tesim: ["Dame, Humun"],
      keyword_tesim: ["Da Vinci"],
      rights_statement_tesim: ["http://rightsstatements.org/vocab/NKC/1.0/"],
      thumbnail_path_ss: "/downloads/5766d215-ac1c-440a-88cc-48854c30ae77?file=thumbnail",
      suppressed_bsi: false,
      actionable_workflow_roles_ssim: ["admin_set/default-default-approving",
                                       "admin_set/default-default-depositing",
                                       "admin_set/default-default-managing"],
      workflow_state_name_ssim: ["deposited"],
      member_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30ae77"],
      file_set_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30ae77"],
      visibility_ssi: "open",
      admin_set_tesim: ["Default Admin Set"],
      creator_ssi: "Dame, Humun",
      date_created_ssi: "2021-04-01",
      title_ssi: "Aligator Work",
      sorted_date_isi: 20_210_401,
      sorted_year_isi: 2021,
      human_readable_type_tesim: ["Work"],
      read_access_group_ssim: ["public"],
      edit_access_group_ssim: ["admin"],
      edit_access_person_ssim: [tenant_user.email.to_s],
      nesting_collection__pathnames_ssim: ["111"],
      nesting_collection__deepest_nested_depth_isi: 1
    }
  end

  let(:bunny) do
    {
      system_create_dtsi: "2021-03-08T22:01:36Z",
      system_modified_dtsi: "2021-03-08T22:19:40Z",
      has_model_ssim: ["GenericWork"],
      id: "222",
      accessControl_ssim: ["f331c617-842c-4e95-a5f1-9be171458823"],
      hasRelatedMediaFragment_ssim: ["5766d215-ac1c-440a-88cc-48854c30aenn"],
      hasRelatedImage_ssim: ["5766d215-ac1c-440a-88cc-48854c30aenn"],
      depositor_ssim: [tenant_user.email.to_s],
      depositor_tesim: [tenant_user.email.to_s],
      title_tesim: ["Bunny Work"],
      date_uploaded_dtsi: "2021-03-08T22:01:34Z",
      date_modified_dtsi: "2021-03-08T22:19:40Z",
      isPartOf_ssim: ["admin_set/default"],
      date_created_tesim: ["1921-04-01"],
      creator_tesim: ["Dame, Humun"],
      keyword_tesim: ["Gentileschi"],
      rights_statement_tesim: ["http://rightsstatements.org/vocab/NKC/1.0/"],
      thumbnail_path_ss: "/downloads/5766d215-ac1c-440a-88cc-48854c30aenn?file=thumbnail",
      suppressed_bsi: false,
      actionable_workflow_roles_ssim: ["admin_set/default-default-approving",
                                       "admin_set/default-default-depositing",
                                       "admin_set/default-default-managing"],
      workflow_state_name_ssim: ["deposited"],
      member_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aenn"],
      file_set_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aenn"],
      visibility_ssi: "open",
      admin_set_tesim: ["Default Admin Set"],
      creator_ssi: "Dame, Humun",
      date_created_ssi: "1921-04-01",
      title_ssi: "Bunny Work",
      sorted_date_isi: 19_210_401,
      sorted_year_isi: 1921,
      human_readable_type_tesim: ["Work"],
      read_access_group_ssim: ["public"],
      edit_access_group_ssim: ["admin"],
      edit_access_person_ssim: [tenant_user.email.to_s],
      nesting_collection__pathnames_ssim: ["222"],
      nesting_collection__deepest_nested_depth_isi: 1
    }
  end

  let(:cat) do
    {
      system_create_dtsi: "2021-02-08T22:01:36Z",
      system_modified_dtsi: "2021-02-08T22:19:40Z",
      has_model_ssim: ["GenericWork"],
      id: "333",
      accessControl_ssim: ["f331c617-842c-4e95-a5f1-9be171458844"],
      hasRelatedMediaFragment_ssim: ["5766d215-ac1c-440a-88cc-48854c30aejj"],
      hasRelatedImage_ssim: ["5766d215-ac1c-440a-88cc-48854c30aejj"],
      depositor_ssim: [tenant_user.email.to_s],
      depositor_tesim: [tenant_user.email.to_s],
      title_tesim: ["Cat Work"],
      date_uploaded_dtsi: "2021-02-08T22:01:34Z",
      date_modified_dtsi: "2021-02-08T22:19:40Z",
      isPartOf_ssim: ["admin_set/default"],
      date_created_tesim: ["1321-04-01"],
      creator_tesim: ["Dame, Humun"],
      keyword_tesim: ["Brunelleschi"],
      rights_statement_tesim: ["http://rightsstatements.org/vocab/NKC/1.0/"],
      thumbnail_path_ss: "/downloads/5766d215-ac1c-440a-88cc-48854c30aejj?file=thumbnail",
      suppressed_bsi: false,
      actionable_workflow_roles_ssim: ["admin_set/default-default-approving",
                                       "admin_set/default-default-depositing",
                                       "admin_set/default-default-managing"],
      workflow_state_name_ssim: ["deposited"],
      member_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aejj"],
      file_set_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aejj"],
      visibility_ssi: "open",
      admin_set_tesim: ["Default Admin Set"],
      creator_ssi: "Dame, Humun",
      date_created_ssi: "1321-04-01",
      title_ssi: "Cat Work",
      sorted_date_isi: 13_210_401,
      sorted_year_isi: 1321,
      human_readable_type_tesim: ["Work"],
      read_access_group_ssim: ["public"],
      edit_access_group_ssim: ["admin"],
      edit_access_person_ssim: [tenant_user.email.to_s],
      nesting_collection__pathnames_ssim: ["333"],
      nesting_collection__deepest_nested_depth_isi: 1
    }
  end

  let(:duck) do
    {
      system_create_dtsi: "2021-01-08T22:01:36Z",
      system_modified_dtsi: "2021-01-08T22:19:40Z",
      has_model_ssim: ["GenericWork"],
      id: "444",
      accessControl_ssim: ["f331c617-842c-4e95-a5f1-9be171458898"],
      hasRelatedMediaFragment_ssim: ["5766d215-ac1c-440a-88cc-48854c30aebb"],
      hasRelatedImage_ssim: ["5766d215-ac1c-440a-88cc-48854c30aebb"],
      depositor_ssim: [tenant_user.email.to_s],
      depositor_tesim: [tenant_user.email.to_s],
      title_tesim: ["Duck Work"],
      date_uploaded_dtsi: "2021-01-08T22:01:34Z",
      date_modified_dtsi: "2021-01-08T22:19:40Z",
      isPartOf_ssim: ["admin_set/default"],
      date_created_tesim: ["921-04-01"],
      creator_tesim: ["Dame, Humun"],
      keyword_tesim: ["Donatello"],
      rights_statement_tesim: ["http://rightsstatements.org/vocab/NKC/1.0/"],
      thumbnail_path_ss: "/downloads/5766d215-ac1c-440a-88cc-48854c30aebb?file=thumbnail",
      suppressed_bsi: false,
      actionable_workflow_roles_ssim: ["admin_set/default-default-approving",
                                       "admin_set/default-default-depositing",
                                       "admin_set/default-default-managing"],
      workflow_state_name_ssim: ["deposited"],
      member_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aebb"],
      file_set_ids_ssim: ["5766d215-ac1c-440a-88cc-48854c30aebb"],
      visibility_ssi: "open",
      admin_set_tesim: ["Default Admin Set"],
      creator_ssi: "Dame, Humun",
      date_created_ssi: "921-04-01",
      title_ssi: "Duck Work",
      sorted_date_isi: 9_210_401,
      sorted_year_isi: 921,
      human_readable_type_tesim: ["Work"],
      read_access_group_ssim: ["public"],
      edit_access_group_ssim: ["admin"],
      edit_access_person_ssim: [tenant_user.email.to_s],
      nesting_collection__pathnames_ssim: ["444"],
      nesting_collection__deepest_nested_depth_isi: 1
    }
  end

  before do
    WebMock.disable!
    Apartment::Tenant.create(account.tenant)
    Apartment::Tenant.switch(account.tenant) do
      Site.update(account: account)
    end

    # sign up user 1 at account 1
    tenant_user

    solr = Blacklight.default_index.connection
    solr.add([aligator,
              bunny,
              cat,
              duck])
    solr.commit
  end

  after do
    WebMock.enable!
    Apartment::Tenant.drop(account.tenant)
  end

  xit "gets correct search results using year ranges" do
    visit search_catalog_path

    within "#search-results" do
      expect(page).to have_content("Aligator")
      expect(page).to have_content("Bunny")
      expect(page).to have_content("Cat")
      expect(page).to have_content("Duck")
    end

    fill_in "range_sorted_year_isi_begin", with: "1900"
    fill_in "range_sorted_year_isi_end", with: "2021"
    click_on "Limit"

    within "#search-results" do
      expect(page).to     have_content("Aligator")
      expect(page).to     have_content("Bunny")

      expect(page).not_to have_content("Cat")
      expect(page).not_to have_content("Duck")
    end
  end

  xit "can get years with less than 4 digits" do
    visit search_catalog_path

    within "#search-results" do
      expect(page).to have_content("Aligator")
      expect(page).to have_content("Bunny")
      expect(page).to have_content("Cat")
      expect(page).to have_content("Duck")
    end

    fill_in "range_sorted_year_isi_begin", with: "610"
    fill_in "range_sorted_year_isi_end", with: "950"
    click_on "Limit"

    within "#search-results" do
      expect(page).to have_content("Duck")

      expect(page).not_to have_content("Aligator")
      expect(page).not_to have_content("Bunny")
      expect(page).not_to have_content("Cat")
    end
  end

  it "displays plot after facet is expanded" do
    visit "/catalog/range_limit?commit=Limit&locale=en&q=&range_end=2021&range_field=sorted_year_isi&range_start=2&search_field=all_fields"
    expect(page.status_code).to eq 200
  end
end
