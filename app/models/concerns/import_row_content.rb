# frozen_string_literal: true

module ImportRowContent
  extend ActiveSupport::Concern

  IMPORT_COLUMNS = CreateExpensesFromCsvService::IMPORTABLE_COLUMNS

  def import_row_values
    data = parsed_import_row_hash
    IMPORT_COLUMNS.map { |column| data[column.to_s].presence }
  end

  private

  def parsed_import_row_hash
    JSON.parse(raw_content).stringify_keys
  rescue JSON::ParserError
    legacy_import_row_hash
  end

  def legacy_import_row_hash
    IMPORT_COLUMNS.index_with do |column|
      match = raw_content.match(/:#{column}=>(?:"((?:\\.|[^"\\])*)"|nil)/)
      match ? match[1] : nil
    end.stringify_keys
  end
end
