# frozen_string_literal: true

GenericWork.include(VideoEmbedViewer)
GenericWork.include(::Hyrax::WorkBehavior)
GenericWork.include(DogBiscuits::Abstract)
GenericWork.include(DogBiscuits::BibliographicCitation)
GenericWork.include(DogBiscuits::DateIssued)
GenericWork.include(DogBiscuits::Geo)
GenericWork.include(DogBiscuits::PartOf)
GenericWork.include(DogBiscuits::PlaceOfPublication)
GenericWork.include(SlugBug)
GenericWork.include(IiifPrint.model_configuration(
  pdf_split_child_model: self,
  pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
  derivative_service_plugins: [
    IiifPrint::TextExtractionDerivativeService
  ]
))

# This must come after the properties because it finalizes the metadata
# schema (by adding accepts_nested_attributes)
GenericWork.include SlugMetadata
GenericWork.include AdventistMetadata

GenericWork.instance_variable_set(:@generated_resource_class, nil)
GenericWork.resource_class

GenericWork.resource_class.send(:include, SlugMetadata)
GenericWork.resource_class.send(:include, AdventistMetadata)
GenericWork.resource_class.send(:include, VideoEmbedViewer)
GenericWork.resource_class.send(:include, DogBiscuits::Abstract)
GenericWork.resource_class.send(:include, DogBiscuits::BibliographicCitation)
GenericWork.resource_class.send(:include, DogBiscuits::DateIssued)
GenericWork.resource_class.send(:include, DogBiscuits::Geo)
GenericWork.resource_class.send(:include, DogBiscuits::PartOf)
GenericWork.resource_class.send(:include, DogBiscuits::PlaceOfPublication)
GenericWork.resource_class.send(:include, SlugBug)
