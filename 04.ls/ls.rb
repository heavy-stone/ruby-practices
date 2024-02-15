#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WHITESPACE_BETWEEN_FILE_NAMES = 2
DISPLAYED_COLUMN = 3
CURRENT_DIRECTORY = '.'

def main
  options = ARGV.getopts('a')
  paths = ARGV.empty? ? [CURRENT_DIRECTORY] : ARGV
  print ls(options, paths)
end

def ls(options, paths = [CURRENT_DIRECTORY])
  valid_paths = validate_paths(paths)
  create_output(valid_paths, each_path_filenames(options, valid_paths))
end

def validate_paths(paths)
  paths.sort.filter do |path|
    unless Dir.exist?(path)
      puts "ls: #{path}: No such file or directory"
      next
    end
    path
  end
end

def each_path_filenames(options, paths)
  if options['a']
    paths.map { |path| Dir.entries(path) }
  else
    paths.map { |path| Dir.glob('*', base: path) }
  end
end

def create_output(paths, each_path_filenames)
  if paths.length > 1
    paths.zip(each_path_filenames).map do |path, filenames|
      "#{path}:\n#{create_filenames(filenames)}"
    end.join("\n")
  else
    create_filenames(*each_path_filenames)
  end
end

def create_filenames(filenames)
  return if filenames.empty?

  ljust_width = filenames.max_by(&:length).length + WHITESPACE_BETWEEN_FILE_NAMES
  column = filenames.length.ceildiv(DISPLAYED_COLUMN)
  sliced_filenames = filenames.sort.each_slice(column).to_a
  nil_count_for_transpose = column - sliced_filenames[-1].length
  nil_count_for_transpose.times do
    sliced_filenames[-1].push(nil)
  end
  sliced_filenames.transpose.map do |row|
    row.map do |file_name|
      file_name.to_s.ljust(ljust_width)
    end.join
  end.join("\n").concat("\n")
end

main if $PROGRAM_NAME == __FILE__
