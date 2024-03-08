#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('clw')
  has_no_option = !options['c'] && !options['l'] && !options['w']
  options = { 'l' => true, 'w' => true, 'c' => true } if has_no_option
  print wc(options, ARGV)
end

def wc(options, files = [])
  if files.empty?
    lines = $stdin.readlines
    file_table = [create_file_field_hash_with_lines('', lines)]
  else
    file_table = files.map { |file| create_file_field_hash(file) }
  end
  total_field_hash = create_total_field_hash(file_table)
  create_output(file_table, total_field_hash, options)
end

def create_file_field_hash(file)
  error_message =
    if File.directory?(file)
      "wc: #{file}: read: Is a directory\n"
    elsif File.exist?(file)
      ''
    else
      "wc: #{file}: open: No such file or directory\n"
    end

  if error_message.empty?
    lines = File.readlines(file)
    create_file_field_hash_with_lines(file, lines)
  else
    create_file_field_hash_with_lines('', [], error_message)
  end
end

def create_file_field_hash_with_lines(file, lines, error_message = '')
  words = lines.join.split
  bytes = lines.join.bytesize
  { line_length: lines.length, word_length: words.length, bytes:, label: file, error_message: }
end

def create_total_field_hash(file_table)
  line_length = file_table.sum { |file| file[:line_length] }
  word_length = file_table.sum { |file| file[:word_length] }
  bytes = file_table.sum { |file| file[:bytes] }
  { line_length:, word_length:, bytes:, label: 'total' }
end

def create_output(file_table, total_field_hash, options)
  output = file_table.map do |file_field_hash|
    if file_field_hash[:error_message].empty?
      format_output(file_field_hash, total_field_hash, options)
    else
      file_field_hash[:error_message]
    end
  end.join
  output += format_output(total_field_hash, total_field_hash, options) if file_table.length > 1
  output
end

def format_output(file_field_hash, total_field_hash, options)
  key_to_has_option = { line_length: options['l'], word_length: options['w'], bytes: options['c'] }
  total_field_hash.map do |key, value|
    if key == :label
      " #{file_field_hash[:label]}\n"
    else
      width = value.to_s.length
      "\t#{file_field_hash[key].to_s.rjust(width)}" if key_to_has_option[key]
    end
  end.join
end

main if $PROGRAM_NAME == __FILE__
