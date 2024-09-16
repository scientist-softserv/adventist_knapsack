# frozen_string_literal: true

GenericWorkResource.include Hyrax::Schema(:slug_metadata)
GenericWorkResource.include(SlugBugValkyrie)
GenericWorkResource.prepend(IiifPrint.model_configuration(
                            pdf_split_child_model: GenericWorkResource,
                            pdf_splitter_service: IiifPrint::SplitPdfs::AdventistPagesToJpgsSplitter,
                            derivative_service_plugins: [
                              IiifPrint::TextExtractionDerivativeService
                            ]
                          ))
