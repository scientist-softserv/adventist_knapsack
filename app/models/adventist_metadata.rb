# frozen_string_literal: true

##
# metadata copied from hyrax/app/models/concerns/hyrax/basic_metadata.rb as of
# v3.0.0, then altered to override date created to accept scalar data from the
# date picker.
module AdventistMetadata
  extend ActiveSupport::Concern

  included do
    property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false

    property :relative_path, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false

    property :import_url, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false

    property :remote_url, predicate: ::RDF::Vocab::Identifiers.uri do |index|
      index.as :stored_searchable
    end

    property :resource_type, predicate: ::RDF::Vocab::DC.type
    property :creator, predicate: ::RDF::Vocab::DC11.creator
    property :contributor, predicate: ::RDF::Vocab::DC11.contributor
    property :description, predicate: ::RDF::Vocab::DC11.description
    property :keyword, predicate: ::RDF::Vocab::DC11.relation
    # Used for a license
    property :license, predicate: ::RDF::Vocab::DC.rights

    # This is for the rights statement
    property :rights_statement, predicate: ::RDF::Vocab::EDM.rights
    property :publisher, predicate: ::RDF::Vocab::DC11.publisher
    property :date_created, predicate: ::RDF::Vocab::DC.created, multiple: false do |index|
      index.as :stored_searchable
    end
    property :subject, predicate: ::RDF::Vocab::DC11.subject
    property :language, predicate: ::RDF::Vocab::DC11.language
    property :identifier, predicate: ::RDF::Vocab::DC.identifier
    property :based_near, predicate: ::RDF::Vocab::FOAF.based_near, class_name: Hyrax::ControlledVocabularies::Location

    # Due to the mappings for Bulkrax the "related_url" is not exposed as a field we can "import
    # into".  What do I mean by that?  For importers we map the related_url to "remote_files" then
    # ingest those files.  However, we do also expose a means of assigning a "related_url" via the
    # UI.  In that case we don't map that input to "remote_files" and instead write to the
    # "related_url" property.
    property :related_url, predicate: ::RDF::RDFS.seeAlso
    property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation
    property :source, predicate: ::RDF::Vocab::DC.source do |index|
      index.as :stored_searchable, :facetable
    end

    id_blank = proc { |attributes| attributes[:id].blank? }

    class_attribute :controlled_properties
    self.controlled_properties = [:based_near]
    accepts_nested_attributes_for :based_near, reject_if: id_blank, allow_destroy: true
  end
end
