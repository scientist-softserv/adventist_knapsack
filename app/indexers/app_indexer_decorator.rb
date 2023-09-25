# frozen_string_literal: true

module AppIndexerDecorator

  # rubocop:disable Metrics/AbcSize
  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc["account_cname_tesim"] = Site.instance&.account&.cname

      solr_doc['creator_ssi'] = object.creator.first.titlecase if object.creator.present?
      solr_doc['date_created_ssi'] = object.date_created if object.date_created.present?
      solr_doc['title_ssi'] = object.title.first.titlecase if object.title.present?
      solr_doc['fedora_id_ssi'] = object.id
      solr_doc[ActiveFedora.id_field.to_sym] = object.to_param
      solr_doc['source_sim'] = solr_doc['source_tesim']
      solr_doc['file_set_text_tsimv'] = child_works_file_sets(object: object).map { |fs| all_text(object: fs) }
        .select(&:present?)
        .join("\n---------------------------\n")

      if object.date_created.present?
        # rubocop:disable Metrics/LineLength
        date_created = object.date_created.is_a?(ActiveTriples::Relation) ? object.date_created.first : object.date_created
        # rubocop:enable Metrics/LineLength
        # expects date created to be array with single string in yyyy-mm-dd format
        solr_doc['sorted_date_isi'] = date_created.tr('-', '').to_i
        solr_doc['sorted_month_isi'] = date_created.tr('-', '').slice(0..5).to_i
        solr_doc['sorted_year_isi'] = date_created.slice(0..3).to_i
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def child_works_file_sets(object:)
    object.works.map { |work| work.file_sets.to_a }.flatten
  end

  def all_text(object:)
    text = IiifPrint::Data::WorkDerivatives.data(from: object, of_type: 'txt') || ''
    return text if text.empty?

    text.tr("\n", ' ').squeeze(' ')
  end
end

AppIndexer.prepend(AppIndexerDecorator)
