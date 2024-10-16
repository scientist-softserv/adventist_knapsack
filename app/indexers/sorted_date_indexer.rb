# frozen_string_literal: true

##
# A mixin for Valkyrie resources to support Date Range facet.
module SortedDateIndexer
  # rubocop:disable Metrics/BlockLength
  def to_solr
    super.tap do |index_document|
      if resource.date_created.present?
        formatted_date = format_date(resource.date_created)

        if formatted_date.present?
          index_document['sorted_date_isi'] = format_full_date(formatted_date)
          index_document['sorted_month_isi'] = format_year_month(formatted_date)
          index_document['sorted_year_isi'] = format_year(formatted_date)
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength

  private

  # converts dates to format: 'yyyy-mm-dd'
  def format_date(date_created)
    date_created = date_created.is_a?(Array) ? date_created.first : date_created

    return "#{date_created}-01-01" if date_created.match?(/\A\d{4}\z/)

    return date_created if date_created.match?(/\A\d{4}-\d{2}-\d{2}\z/)

    begin
      parsed_date = if date_created.match?(/\A\d{2}\/\d{2}\/\d{4}\z/)
                      Date.strptime(date_created, '%m/%d/%Y')
                    else
                      Date.parse(date_created)
                    end
      parsed_date.strftime('%Y-%m-%d')
    rescue ArgumentError
      Rails.logger.warn("Unable to parse date: #{date_created}")
      nil
    end
  end

  # Format for full date: yyyyMMdd
  def format_full_date(formatted_date)
    formatted_date.delete('-').to_i
  end

  # Format for year and month: yyyyMM
  def format_year_month(formatted_date)
    formatted_date.slice(0..6).delete('-').to_i
  end

  # Format for year only: yyyy
  def format_year(formatted_date)
    formatted_date.slice(0..3).to_i
  end
end
