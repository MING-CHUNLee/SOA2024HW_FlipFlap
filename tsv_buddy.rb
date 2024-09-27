# frozen_string_literal: true

# Module that can be included (mixin) to take and output TSV data
module TsvBuddy
  TAB = "\t"
  NEWLINE = "\n"
  NIL = ''
  attr_reader :data

  def take_tsv(tsv)
    lines = tsv.split(NEWLINE)
    headers = extract_headers(lines[0])
    @data = parse_rows(lines[1..], headers)
  end

  def to_tsv(include_header: true)
    return 'No data available' if @data&.empty?

    headers = include_header ? "#{@data.first.keys.join(TAB)}\n" : NIL
    rows = @data.map { |record| record.values.join(TAB) }
    "#{headers}#{rows.join(NEWLINE)}\n"
  end

  private

  def extract_headers(header_line)
    headers = header_line.strip.split(TAB)
    raise 'No headers found' if headers.empty?

    headers
  end

  def parse_rows(lines, headers)
    lines.map { |row| tsv_row_to_hash(row, headers) }
  end

  def tsv_row_to_hash(row, headers)
    values = row.strip.split(TAB)
    build_hash(headers, values)
  end

  def build_hash(headers, values)
    headers.each_with_index.with_object({}) do |(header, index), hash|
      hash[header] = values[index] || NIL
    end
  end
end
