# frozen_string_literal: true

# OVERRIDE BULKRAX v5.4.1 to add BOM encoding support when reading CSVs

require 'csv'

module Bulkrax
  module CsvEntryDecorator
    module ClassMethods
      def read_data(path)
        raise StandardError, 'CSV path empty' if path.blank?
        options = {
          headers: true,
          header_converters: ->(h) { h.to_s.strip.to_sym },
          encoding: 'bom|utf-8'
        }.merge(csv_read_data_options)

        results = CSV.read(path, **options)
        csv_wrapper_class.new(results)
      end
    end
  end
end

Bulkrax::CsvEntry.singleton_class.prepend(Bulkrax::CsvEntryDecorator::ClassMethods)
