#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

WHITESPACE_BETWEEN_FILENAMES = 2
DISPLAYED_COLUMN = 3
CURRENT_DIRECTORY = '.'
FULL_WIDTH_REGEX = /[^ -~｡-ﾟ]/

def main
  options = ARGV.getopts('ar')
  paths = ARGV.empty? ? [CURRENT_DIRECTORY] : ARGV
  print ls(options, paths)
end

def ls(options, paths = [CURRENT_DIRECTORY])
  valid_paths = validate_paths(paths)
  valid_paths = valid_paths.reverse if options['r']
  each_path_filenames = each_path_filenames(options, valid_paths)
  each_path_filenames = each_path_filenames.map(&:reverse) if options['r']
  create_output(valid_paths, each_path_filenames)
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
    paths.map { |path| Dir.entries(path).sort } # ..の表示を含めるためentriesを使用
  else
    paths.map { |path| Dir.glob('*', base: path).sort }
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

  max_length_filename = filenames.max_by do |filename|
    filename.length + filename.scan(FULL_WIDTH_REGEX).count # 全角文字は2文字としてカウントするため
  end
  ljust_width =
    max_length_filename.length +
    max_length_filename.scan(FULL_WIDTH_REGEX).count +
    WHITESPACE_BETWEEN_FILENAMES
  column = filenames.length.ceildiv(DISPLAYED_COLUMN)
  sliced_filenames = filenames.each_slice(column).to_a
  nil_count_for_transpose = column - sliced_filenames[-1].length
  nil_count_for_transpose.times do
    sliced_filenames[-1].push(nil)
  end
  sliced_filenames.transpose.map do |row|
    row.map do |filename|
      filename = filename.to_s if filename.nil?
      filename.ljust(ljust_width - filename.scan(FULL_WIDTH_REGEX).count)
    end.join
  end.join("\n").concat("\n")
end

main if $PROGRAM_NAME == __FILE__
