# frozen_string_literal: true

# OVERRIDE BULKRAX v5.4.1 to add BOM support when parsing values

module Bulkrax
  module AdventistCsvParserDecorator
    def missing_elements(record)
      keys_from_record = extract_keys_from_record(record)
      keys = collect_keys_from_mapping(keys_from_record)
      required_elements_str = normalize_elements(required_elements)

      identify_missing_elements(required_elements_str, keys)
    end

    private

    def extract_keys_from_record(record)
      keys = record.reject { |_, v| v.blank? }
                   .keys
                   .compact
                   .uniq
                   .map(&:to_s)
                   .map(&:strip)
                   .map { |k| Bulkrax.normalize_string(k) }
      keys_without_numbers(keys)
    end

    def collect_keys_from_mapping(keys_from_record)
      keys = []
      importerexporter.mapping.stringify_keys.each do |k, v|
        Array.wrap(v['from']).each do |vf|
          vf_str = Bulkrax.normalize_string(vf.to_s.strip)
          keys << k.to_s.strip if keys_from_record.include?(vf_str)
        end
      end
      keys.uniq.map(&:to_s).map(&:strip).map { |k| Bulkrax.normalize_string(k) }
    end

    def normalize_elements(elements)
      elements.map(&:to_s).map(&:strip).map { |k| Bulkrax.normalize_string(k) }
    end

    def identify_missing_elements(required_elements, keys)
      required_elements - keys
    end
  end
end

Bulkrax::CsvParser.prepend(Bulkrax::AdventistCsvParserDecorator)
