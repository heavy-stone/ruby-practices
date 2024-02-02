#!/usr/bin/env ruby
# frozen_string_literal: true

WHITESPACE_BETWEEN_FILE_NAMES = 2
DISPLAYED_COLUMN = 3

def main
  puts ls(Dir.glob('*'))
end

def ls(input_file_names)
  ljust_width = input_file_names.max_by(&:length).length + WHITESPACE_BETWEEN_FILE_NAMES
  quotient, remainder = input_file_names.length.divmod(DISPLAYED_COLUMN)
  column = quotient + (remainder.positive? ? 1 : 0)
  sliced_input_file_names = input_file_names.sort.each_slice(column).to_a
  nil_count_for_transpose = column - sliced_input_file_names[-1].length
  if remainder.positive?
    nil_count_for_transpose.times do
      sliced_input_file_names[-1].push(nil)
    end
  end
  sliced_input_file_names.transpose.inject('') do |result, row|
    row.each do |file_name|
      result += file_name.to_s.ljust(ljust_width)
    end
    result += "\n"
  end
end

main
