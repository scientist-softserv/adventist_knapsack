# frozen_string_literal: true

CatalogController.include DogBiscuits::Blacklight::Commands
CatalogController.configure_blacklight do |config|
  # Use locally customized AdvSearchBuilder so we can enable blacklight_advanced_search
  config.search_builder_class = AdvSearchBuilder

  # solr fields that will be treated as facets by the blacklight application
  #   The ordering of the field names is the order of the display
  config.add_facet_field 'source_sim', label: 'Source', limit: 5, collapse: false
  config.add_facet_field(
    'sorted_year_isi',
    label: 'Date Range',
    range: {
      facet_field_label: 'Date Range',
      num_segments: 10,
      assumed_boundaries: [1100, Time.zone.now.year + 2],
      segments: false,
      slider_js: false,
      maxlength: 4
    },
    facet_field_label: 'Date Range'
  )

  # Delete Hyku version so we can add the Author label
  config.facet_fields.delete('creator_sim')
  config.add_facet_field 'creator_sim', label: "Author", limit: 5

  # Delete default Hyku facets that are no applicable for this Knapsack
  config.facet_fields.delete('contributor_sim')
  config.facet_fields.delete('file_format_sim')

  config.add_facet_field 'part_sim', limit: 5, label: 'Part'
  config.add_facet_field 'part_of_sim', limit: 5
  config.add_facet_field 'refereed_sim', limit: 5

  # Clobber all existing index and show fields that come from Hyku base but skip
  # the non-DogBiscuit keys that Adventist had already configured in a pre-Knapsack state
  # see: https://github.com/scientist-softserv/adventist-dl/blob/97bd05946345926b2b6c706bd90e183a9d78e8ef/app/controllers/catalog_controller.rb#L38-L40
  config.index_fields.keys.each do |key|
    next if key == 'all_text_timv'
    next if key == 'file_set_text_tsimv'

    config.index_fields.delete(key)
  end

  ##
  # When we specify the index fields, blacklight caches those translations.  However, in the case of
  # dogbiscuits, those are not yet loaded.  Which results in a translation error; even though we
  # later load the dog biscuits translations.
  HykuKnapsack::Engine.load_translations!

  index_props = DogBiscuits.config.index_properties.collect do |prop|
    { prop => CatalogController.send(:index_options, prop, DogBiscuits.config.property_mappings[prop]) }
  end
  CatalogController.send(:add_index_field, config, index_props)

  config.search_fields.delete('all_fields')
  config.add_search_field('all_fields',
                          label: 'All Fields',
                          include_in_advanced_search: false,
                          advanced_parse: false) do |field|
    all_names = (config.show_fields.values.map { |v| v.field.to_s } +
                 DogBiscuits.config.all_properties.map { |p| "#{p}_tesim" }).uniq.join(" ")
    title_name = 'title_tesim'
    field.solr_parameters = {
      qf: "#{all_names} file_format_tesim all_text_timv",
      pf: title_name.to_s
    }
  end

  # TODO: We may remove this block if Hyku changes the creator label to Author
  config.search_fields.delete('creator')
  config.add_search_field('creator') do |field|
    field.label = "Author"
    field.solr_parameters = { "spellcheck.dictionary": "creator" }
    solr_name = 'creator_tesim'
    field.solr_local_parameters = {
      qf: solr_name,
      pf: solr_name
    }
  end

  # TODO: We may remove this block if Hyku changes the date_created search field solr_name
  config.search_fields.delete('date_created')
  config.add_search_field('date_created') do |field|
    field.solr_parameters = {
      "spellcheck.dictionary": "date_created"
    }
    solr_name = ['date_created_tesim', 'sorted_date_isi', 'sorted_month_isi'].join(' ')
    field.solr_local_parameters = {
      qf: solr_name,
      pf: solr_name
    }
  end

  # Remove all existing sort fields and add the ones we want
  config.sort_fields.keys.each do |key|
    config.sort_fields.delete(key)
  end

  # TODO: replace CatalogController.title_field to return 'title_ssi'
  config.add_sort_field "title_ssi asc", label: "Title"
  # TODO: replace CatalogController.creator_field to return 'creator_ssi'
  config.add_sort_field "creator_ssi asc", label: "Author"
  # TODO: replace CatalogController.created_field to return 'created_ssi'
  config.add_sort_field "created_ssi asc", label: "Published Date (Ascending)"
  config.add_sort_field "created_ssi desc", label: "Published Date (Descending)"
  config.add_sort_field "#{CatalogController.modified_field} asc", label: "Upload Date (Ascending)"
  config.add_sort_field "#{CatalogController.modified_field} desc", label: "Upload Date (Descending)"
end
# rubocop:enable Metrics/BlockLength
