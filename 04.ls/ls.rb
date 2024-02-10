#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WHITESPACE_BETWEEN_FILE_NAMES = 2
DISPLAYED_COLUMN = 3

def main
  options = ARGV.getopts('a')
  puts ls(options)
end

def ls(options)
  if options['a']
    create_output(Dir.entries('.'))
  else
    create_output(Dir.glob('*'))
  end
end

def create_output(input_file_names)
  ljust_width = input_file_names.max_by(&:length).length + WHITESPACE_BETWEEN_FILE_NAMES
  column = input_file_names.length.ceildiv(DISPLAYED_COLUMN)
  sliced_input_file_names = input_file_names.sort.each_slice(column).to_a
  nil_count_for_transpose = column - sliced_input_file_names[-1].length
  nil_count_for_transpose.times do
    sliced_input_file_names[-1].push(nil)
  end
  sliced_input_file_names.transpose.map do |row|
    row.map do |file_name|
      file_name.to_s.ljust(ljust_width)
    end.join
  end.join("\n")
end

main if $PROGRAM_NAME == __FILE__
