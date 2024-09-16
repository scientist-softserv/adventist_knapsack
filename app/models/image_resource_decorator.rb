# frozen_string_literal: true

ImageResource.include Hyrax::Schema(:slug_metadata)
ImageResource.include(SlugBugValkyrie)
ImageResource.prepend(IiifPrint.model_configuration(
                      pdf_split_child_model: ImageResource,
                      pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
                      derivative_service_plugins: [
                        IiifPrint::TextExtractionDerivativeService
                      ]
                    ))
