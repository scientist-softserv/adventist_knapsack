# frozen_string_literal: true

# load dog_biscuits config
DOGBISCUITS = YAML.safe_load(File.read(Rails.root.join('config', 'dog_biscuits.yml'))).with_indifferent_access
# include Terms
# Qa::Authorities::Local.register_subauthority('concepts', 'DogBiscuits::Terms::ConceptsTerms')
# Qa::Authorities::Local.register_subauthority('projects', 'DogBiscuits::Terms::ProjectsTerms')
# Qa::Authorities::Local.register_subauthority('organisations', 'DogBiscuits::Terms::OrganisationsTerms')
# Qa::Authorities::Local.register_subauthority('places', 'DogBiscuits::Terms::PlacesTerms')
# Qa::Authorities::Local.register_subauthority('people', 'DogBiscuits::Terms::PeopleTerms')
# Qa::Authorities::Local.register_subauthority('groups', 'DogBiscuits::Terms::GroupsTerms')
# Qa::Authorities::Local.register_subauthority('events', 'DogBiscuits::Terms::EventsTerms')
# Qa::Authorities::Local.register_subauthority('departments', 'DogBiscuits::Terms::DepartmentsTerms')

# Configuration
DogBiscuits.config do |config|
  # GLOBAL PROPERTIES

  # Models to be used in the current application.
  #   Available models are: ConferenceItem, Dataset, DigitalArchivalObject, ExamPaper, JournalArticle, Package, PublishedWork, Thesis
  #   Add values in constantized form, eg. 'ConferenceItem'
  config.selected_models = %w[ConferenceItem Dataset ExamPaper JournalArticle PublishedWork Thesis]

  # Use the blacklight date range gem to provide a single combined range filter
  #   default = false
  #   nb. run rails g dog_biscuits:dates_generator to install
  config.date_range = true

  # Use the bootstrap date picker for date fields
  #   default = false
  #   nb. run rails g dog_biscuits:dates_generator to install
  config.date_picker = true

  # Date fields on which to apply the date picker
  #   default is everything in the date_properties config
  #   Add values as symbols (eg. :date_created)
  # config.date_picker_dates += [] # add to the list
  # config.date_picker_dates -= [] # remove from the list
  # config.date_picker_dates += [] # replace the current list

  # Date fields to be indexed into the date_range facet:
  #   Add values as symbols (eg. :date_created)
  # config.date_properties += [] # add to the list
  # config.date_properties -= [] # remove from the list
  # config.date_properties += [] # replace the current list

  # Solr fields that will be used as facets in the search page.
  #   The ordering of the field names is the order of the display
  #   The properties must have been indexed as facetable
  #   Add values as symbols (eg. :creator)
  # config.index_properties = [] # replace the current list
  # config.facet_only_properties -= [:contributor_type] # remove from the current list
  # config.facet_properties = [] # replace the current list

  # Solr fields to be displayed in the index (search results) view
  #   The ordering of the field names is the order of the display
  #   Add values as symbols (eg. :creator)
  # config.index_properties += [] # add to the end of the current list
  # config.index_properties -= [] # remove from the current list
  config.index_properties = [:title, :creator, :part_of, :date_issued, :subject, :source, :description] # replace the current list
  # config.index_properties += [] # add to the end of the current list

  # Solr fields to exclude from search
  #   Add values as symbols (eg. :creator)
  # config.exclude_from_search_properties += [] # add to the end of the current list
  # config.exclude_from_search_properties -= [] # remove from the current list
  # config.exclude_from_search_properties = [] # replace the current list

  # Fields in the form that should only accept a single value, ie. disable the 'add another' button.
  #   Add values as symbols (eg. :creator)
  # config.singular_properties += [] # add to the list
  # config.singular_properties -= [] # remove from the list
  # config.singular_properties += [] # replace the current list

  # Date properties
  # These will be indexed into the date_picker if present
  # config.date_properties += []

  # Enable restricted properties in the form.
  # If set to false, no restrictions will be applied
  # Default is false
  # config.restricted_properties_enabled = false

  # Restrict the following properties in the form to the role specified in
  #   restricted_role
  # Restrictions apply to 'below the fold' properties only, they are not
  #   applied to required properties
  # Restrictions apply in the form only, properties are still visible in the
  #   show page
  # Required current_user to respond to the role ( current_user.admin? )
  #   this is provided by the 'hydra-role-management' gem
  # config.restricted_properties_enabled? must be set to true for this to take effect
  # config.restricted_properties = []

  # Role to use when restricting properties
  # Default is :admin
  # config.restricted_role = :admin

  # Add values that aren't found in the following table-based authorities to be added on save.
  #   This only works in cases where the name of the authority is a pluralized form of
  #   the name of the property which uses it, eg. subjects/subject and languages/language
  # Default is :subjects; add authority name as symbol, eg. :subjects
  # config.authorities_add_new = []

  # WORK PROPERTIES

  # For each model, there are two configurations available.
  # Both are set to defaults:
  #    _required fields defaults to the Hyrax default (title, creator, keyword, rights_statment)
  #    _properties defaults to all properties available to that model, alphabetized
  #  Example:
  #    config.conference_item_properties = []

  config.conference_item_properties = %i[
    title
    creator
    resource_type
    abstract
    presented_at
    location
    event_date
    part_of
    editor
    publisher
    place_of_publication
    date_published
    publication_status
    refereed
    pagination
    doi
    related_url
    identifier
    subject
    keyword
    language
    based_near
    rights_statement
    license
    aark_id
  ]
  config.conference_item_properties_required = Hyrax::GenericWorkForm.required_fields

  config.dataset_properties = %i[
    creator
    title
    publisher
    date_published
    resource_type_general
    resource_type
    abstract
    contributor
    funder
    output_of
    date_collected
    date_created
    date_issued
    doi
    identifier
    subject
    keyword
    language
    based_near
    dc_format
    extent
    related_url
    rights_statement
    license
    source
    aark_id
  ]
  config.dataset_properties_required = Hyrax::GenericWorkForm.required_fields

  config.exam_paper_properties = %i[
    creator
    title
    resource_type
    date_created
    department
    publisher
    qualification_level
    qualification_name
    module_code
    description
    subject
    keyword
    language
    related_url
    rights_statement
    license
    source
    aark_id
  ]
  config.exam_paper_properties_required = Hyrax::GenericWorkForm.required_fields

  config.journal_article_properties = %i[
    title
    creator
    resource_type
    date_created
    part_of
    license
    abstract
    volume_number
    issue_number
    pagination
    publication_status
    refereed
    date_submitted
    date_accepted
    date_available
    date_published
    doi
    remote_url
    identifier
    contributor
    publisher
    output_of
    subject
    keyword
    language
    based_near
    related_url
    rights_statement
    source
    aark_id
    place_of_publication
    date_issued
    bibliographic_citation
    alt
  ]
  config.journal_article_properties_required = Hyrax::GenericWorkForm.required_fields

  config.published_work_properties = %i[
    title
    creator
    resource_type
    editor
    edition
    place_of_publication
    publisher
    date_published
    date_created
    date_available
    part
    pagination
    series
    abstract
    subject
    keyword
    language
    based_near
    isbn
    doi
    remote_url
    identifier
    related_url
    license
    rights_statement
    source
    aark_id
    extent
    date_issued
    alt
    bibliographic_citation
  ]
  config.published_work_properties_required = Hyrax::GenericWorkForm.required_fields

  config.thesis_properties = %i[
    title
    creator
    resource_type
    advisor
    awarding_institution
    abstract
    date_created
    date_of_award
    qualification_level
    qualification_name
    department
    publisher
    funder
    doi
    remote_url
    identifier
    subject
    keyword
    language
    based_near
    related_url
    license
    rights_statement
    source
    aark_id
    part_of
    place_of_publication
    extent
    date_issued
    bibliographic_citation
    alt
  ]
  config.thesis_properties_required = Hyrax::GenericWorkForm.required_fields

  # PROPERTY MAPPINGS
  config.property_mappings[:bibliographic_citation] = { label: 'Bibliographic Citation' }
  config.property_mappings[:part] = { label: 'Part', render_as: :faceted }
  config.property_mappings[:part_of] = { label: 'Part of', render_as: :faceted }
  # config.property_mappings[:human_readable_type] = { collapse: false }
  # config.property_mappings[:sorted_year] = { collapse: false }
  # All properties should be included in property_mappings. This is used by generators for building
  #   schema_org, locales, catalog_controller and attribute_rows. Adding info here and using
  #   generators saves on a lot of manual editing.
  #
  # To add a new local property (new_property below), do:
  #   config.property_mappings[:new_property] = {}
  #
  # To change an existing property (existing_property), do:
  #   config.property_mappings[:existing_property] = {}
  #
  # The contents of a property_mappings key:
  #
  #   config.property_mappings[:existing_property] =
  #     {
  #       # REQUIRED (if the property will appear in search results): a string formatted as per the example shown
  #       index: "('existing_property', :stored_searchable)",
  #
  #       # OPTIONAL: label for use in the form, show page, search results and facet
  #       label: 'My Property Label',
  #
  #       # OPTIONAL: help_text for use in the form
  #       help_text: 'Use this to describe something or other',
  #
  #       # OPTIONAL: reference to a renderer used to format the display of the text in the show page
  #       # in this eg. `app/renderers/existing_property_attribute_renderer.rb` must exist
  #       render_as: 'existing_property',
  #
  #       # OPTIONAL reference to a helper method used to format the display of the text in the search results
  #       # in this eg. the `existing_property_helper` method must exist in app/helpers, eg. in hyrax_helper.rb
  #       helper_method: 'existing_property_helper',
  #
  #       # OPTIONAL mapping to a schema.org property to be used in embedded metadata
  #       schema_org: {
  #         # in this eg. we have decided that the closest property match in schema.org is contributor
  #         property: 'contributor'
  #     }
  # }
end
