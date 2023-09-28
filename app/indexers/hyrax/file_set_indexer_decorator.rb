module Hyrax
  module FileSetIndexerDecorator
    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc['hasRelatedMediaFragment_ssim'] = object.representative_id
        solr_doc['hasRelatedImage_ssim'] = object.thumbnail_id
        # Label is the actual file name. It's not editable by the user.
        solr_doc['label_tesim'] = object.label
        solr_doc['label_ssi']   = object.label
        solr_doc['file_format_tesim'] = file_format
        solr_doc['file_format_sim']   = file_format
        solr_doc['file_size_lts'] = object.file_size[0]
        # OVERRIDE Hyrax 3.5 to encode extracted text
        solr_doc['all_text_timv'] = Hyku.utf_8_encode(object.extracted_text.content) if object.extracted_text.present?
        solr_doc['height_is'] = Integer(object.height.first) if object.height.present?
        solr_doc['width_is']  = Integer(object.width.first) if object.width.present?
        solr_doc['visibility_ssi'] = object.visibility
        solr_doc['mime_type_ssi']  = object.mime_type
        # Index the Fedora-generated SHA1 digest to create a linkage between
        # files on disk (in fcrepo.binary-store-path) and objects in the repository.
        solr_doc['digest_ssim'] = digest_from_content
        solr_doc['page_count_tesim']        = object.page_count
        solr_doc['file_title_tesim']        = object.file_title
        solr_doc['duration_tesim']          = object.duration
        solr_doc['sample_rate_tesim']       = object.sample_rate
        solr_doc['original_checksum_tesim'] = object.original_checksum
        solr_doc['alpha_channels_ssi']      = object.try(:alpha_channels)
        solr_doc['original_file_id_ssi']    = original_file_id
        solr_doc['generic_type_si'] = 'FileSet'
        # OVERRIDE Hyrax 3.5 to override default_thumbnail
        solr_doc['override_default_thumbnail_ssi'] = object.override_default_thumbnail
        # OVERRIDE Hyrax 3.5 to index the file set's parent work's title for displaying in the UV
        solr_doc['parent_title_tesim'] = human_readable_label_name(object.parent)

      end
    end
  end
end

Hyrax::FileSetIndexer.prepend Hyrax::FileSetIndexerDecorator
