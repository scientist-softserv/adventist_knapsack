# frozen_string_literal: true

##
# A mixin for all additional Hyku applicable indexing; both Valkyrie and ActiveFedora friendly.
module SortedDateIndexer
  # TODO: Once we've fully moved to Valkyrie, remove the generate_solr_document and move `#to_solr`
  #      to a more conventional method def (e.g. `def to_solr`).  However, we need to tap into two
  #      different inheritance paths based on ActiveFedora or Valkyrie
  [:generate_solr_document, :to_solr].each do |method_name|
    define_method method_name do |*args, **kwargs, &block|
      super(*args, **kwargs, &block).tap do |index_document|
        # rubocop:disable Style/ClassCheck

        # Active Fedora refers to object
        # Specs refer to object as @object
        # Valkyrie refers to resource
        object ||= @object || resource
        if resource.date_created.present?
          # rubocop:disable Layout/LineLength
          date_created = resource.date_created.is_a?(ActiveTriples::Relation) ? resource.date_created.first : resource.date_created
          # rubocop:enable Layout/LineLength
          # Handle date if it's an array (assuming a single date in array)
          date_created = date_created.is_a?(Array) ? date_created.first : date_created
        
          # Check if the date is already in 'yyyy-mm-dd' format
          if date_created.match?(/\A\d{4}-\d{2}-\d{2}\z/)
            formatted_date = date_created
          else
            # Try to handle dates in "mm/dd/yyyy" format
            begin
              if date_created.match?(/\A\d{2}\/\d{2}\/\d{4}\z/)
                # Parse mm/dd/yyyy format and convert to yyyy-mm-dd
                parsed_date = Date.strptime(date_created, '%m/%d/%Y')
              else
                # Attempt to parse other date formats
                parsed_date = Date.parse(date_created)
              end
              formatted_date = parsed_date.strftime('%Y-%m-%d')
            rescue ArgumentError
              # Log or handle if the date can't be parsed
              Rails.logger.warn("Unable to parse date: #{date_created}")
              formatted_date = nil
            end
          end
        
          if formatted_date.present?
            # Format for full date: yyyyMMdd
            index_document['sorted_date_isi'] = formatted_date.delete('-').to_i
        
            # Format for year and month: yyyyMM
            index_document['sorted_month_isi'] = formatted_date.slice(0..6).delete('-').to_i
        
            # Format for year only: yyyy
            index_document['sorted_year_isi'] = formatted_date.slice(0..3).to_i
          end
        end
        
      end
    end
  end
end
