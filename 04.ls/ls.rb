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

  ljust_width = 0
  each_filename_full_width_counts = filenames.map do |filename|
    full_width_count = filename.scan(FULL_WIDTH_REGEX).count # 全角文字は2文字としてカウントするため
    width = filename.length + full_width_count + WHITESPACE_BETWEEN_FILENAMES
    ljust_width = width if width > ljust_width
    [filename, full_width_count]
  end
  column = each_filename_full_width_counts.length.ceildiv(DISPLAYED_COLUMN)
  sliced_each_filename_full_width_counts = each_filename_full_width_counts.each_slice(column).to_a
  dummy_count_for_transpose = column - sliced_each_filename_full_width_counts[-1].length
  dummy_count_for_transpose.times do
    sliced_each_filename_full_width_counts[-1].push(['', 0]) # 末尾の配列の要素数を揃えるためdummyとして['', 0]を追加
  end
  sliced_each_filename_full_width_counts.transpose.map do |row|
    row.map do |filename, full_width_count|
      filename.ljust(ljust_width - full_width_count)
    end.join
  end.join("\n").concat("\n")
end

main if $PROGRAM_NAME == __FILE__
