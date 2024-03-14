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
    file_content_counts = [to_file_content_counts('', lines)]
  else
    file_content_counts = files.map { |file| to_file_content_counts_from_filename(file) }
  end
  total_file_content_counts = to_total_file_content_counts(file_content_counts)
  format_counts_group(file_content_counts, total_file_content_counts, options)
end

def to_file_content_counts_from_filename(file)
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
    to_file_content_counts(file, lines)
  else
    to_file_content_counts('', [], error_message)
  end
end

def to_file_content_counts(file, lines, error_message = '')
  words = lines.join.split
  bytes = lines.join.bytesize
  { line_length: lines.length, word_length: words.length, bytes:, label: file, error_message: }
end

def to_total_file_content_counts(file_content_counts)
  line_length = file_content_counts.sum { |file| file[:line_length] }
  word_length = file_content_counts.sum { |file| file[:word_length] }
  bytes = file_content_counts.sum { |file| file[:bytes] }
  { line_length:, word_length:, bytes:, label: 'total' }
end

def format_counts_group(file_content_counts, total_file_content_counts, options)
  output = file_content_counts.map do |file_content_count|
    if file_content_count[:error_message].empty?
      format_counts(file_content_count, total_file_content_counts, options)
    else
      file_content_count[:error_message]
    end
  end.join
  output += format_counts(total_file_content_counts, total_file_content_counts, options) if file_content_counts.length > 1
  output
end

def format_counts(file_content_count, total_file_content_counts, options)
  key_to_has_option = { line_length: options['l'], word_length: options['w'], bytes: options['c'] }
  total_file_content_counts.map do |key, value|
    if key == :label
      " #{file_content_count[:label]}\n"
    else
      width = value.to_s.length
      "\t#{file_content_count[key].to_s.rjust(width)}" if key_to_has_option[key]
    end
  end.join
end

main if $PROGRAM_NAME == __FILE__
