# frozen_string_literal: true

  Image.include(::Hyrax::WorkBehavior)
  Image.include(SlugBug)
  Image.include(DogBiscuits::Abstract)
  Image.include(DogBiscuits::BibliographicCitation)
  Image.include(DogBiscuits::DateIssued)
  Image.include(DogBiscuits::Geo)
  Image.include(DogBiscuits::PartOf)
  Image.include(DogBiscuits::PlaceOfPublication)
  Image.include(IiifPrint.model_configuration(
    pdf_split_child_model: self,
    pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
    derivative_service_plugins: [
      IiifPrint::TextExtractionDerivativeService
    ]
  ))

# This must come after the properties because it finalizes the metadata
# schema (by adding accepts_nested_attributes)
Image.include SlugMetadata
Image.include AdventistMetadata

Image.instance_variable_set(:@generated_resource_class, nil)
Image.resource_class

Image.resource_class.send(:include, SlugMetadata)
Image.resource_class.send(:include, AdventistMetadata)
Image.resource_class.send(:include, SlugBug)
Image.resource_class.send(:include, DogBiscuits::Abstract)
Image.resource_class.send(:include, DogBiscuits::BibliographicCitation)
Image.resource_class.send(:include, DogBiscuits::DateIssued)
Image.resource_class.send(:include, DogBiscuits::Geo)
Image.resource_class.send(:include, DogBiscuits::PartOf)
Image.resource_class.send(:include, DogBiscuits::PlaceOfPublication)
