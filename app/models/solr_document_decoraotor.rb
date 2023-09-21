# frozen_string_literal: true

module SolrDocumentDecorator
  extend ActiveSupport::Concern

  # Adds Hyrax behaviors to the SolrDocument.
  include DogBiscuits::ExtendedSolrDocument


  included do
    attribute :slug, Solr::String, solr_name('slug')
    attribute :fedora_id, Solr::String, 'fedora_id_ssi'
    attribute :aark_id, Solr::String, 'aark_id_tesim'
    attribute :bibliographic_citation, Solr::String, solr_name('bibliographic_citation')
    attribute :alt, Solr::String, solr_name('alt')
    attribute :file_set_ids, Solr::Array, 'file_set_ids_ssim'
    attribute :video_embed, Solr::String, 'video_embed_tesim'

    field_semantics.merge!(
      contributor: 'contributor_tesim',
      creator: 'creator_tesim',
      date: 'date_created_tesim',
      description: 'description_tesim',
      identifier: 'aark_id_tesim',
      language: 'language_tesim',
      publisher: 'publisher_tesim',
      relation: 'nesting_collection__pathnames_ssim',
      related_url: 'related_url_tesim',
      rights: 'rights_statement_tesim',
      subject: 'subject_tesim',
      title: 'title_tesim',
      type: 'human_readable_type_tesim'
    )

  end

  def to_param
    slug || id
  end

  def thumbnail_url
    Addressable::URI.parse("https://#{Site.account.cname}#{thumbnail_path}").to_s
  end

  def remote_url
    self[Solrizer.solr_name('remote_url')]
  end

end

SolrDocument.prepend(SolrDocumentDecorator)
