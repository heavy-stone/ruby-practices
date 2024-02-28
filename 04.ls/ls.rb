#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

WHITESPACE_BETWEEN_FILENAMES = 2
DISPLAYED_COLUMN = 3
CURRENT_DIRECTORY = '.'
FULL_WIDTH_REGEX = /[^ -~｡-ﾟ]/
FTYPE_BLOCK_SPECIAL = 'blockSpecial'
FTYPE_CHARACTER_SPECIAL = 'characterSpecial'
FTYPE_DIRECTORY = 'directory'
FTYPE_LINK = 'link'
FTYPE_FIFO = 'fifo'
FTYPE_SOCKET = 'socket'
OCTAL_CHAR_TO_RWX = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  options = ARGV.getopts('arl')
  paths = ARGV.empty? ? [CURRENT_DIRECTORY] : ARGV
  print ls(options, paths)
end

def ls(options, paths = [CURRENT_DIRECTORY])
  has_paths = paths.length > 1
  valid_paths = validate_paths(paths)
  valid_paths = filter_l_option_symlink_directory_paths(options, valid_paths, has_paths)
  valid_paths = valid_paths.reverse if options['r']
  each_path_filenames = create_each_path_filenames(options, valid_paths)
  each_path_filenames = each_path_filenames.map(&:reverse) if options['r']
  create_output(options, valid_paths, each_path_filenames, has_paths)
end

def validate_paths(paths)
  paths.sort.filter do |path|
    unless File.exist?(path)
      print "ls: #{path}: No such file or directory\n"
      next
    end
    path
  end
end

def filter_l_option_symlink_directory_paths(options, paths, has_paths)
  return paths unless options['l']

  valid_paths = paths.filter do |path|
    is_symlink_or_not_directory = !File.directory?(path) || File.symlink?(path)
    if is_symlink_or_not_directory
      _total, long_format_table = create_total_and_long_format_table(path, [], is_symlink_or_not_directory)
      print long_format_table
      next
    end
    path
  end
  print "\n" if has_paths && paths != valid_paths
  valid_paths
end

def create_each_path_filenames(options, paths)
  if options['a']
    paths.map { |path| Dir.entries(path).sort } # ..の表示を含めるためentriesを使用
  else
    paths.map { |path| Dir.glob('*', base: path).sort }
  end
end

def create_output(options, paths, each_path_filenames, has_paths)
  paths.zip(each_path_filenames).map do |path, filenames|
    output =
      if options['l']
        create_long_format_filenames(path, filenames)
      else
        create_filenames(filenames)
      end
    output = "#{path}:\n#{output}" if has_paths
    output
  end.join("\n")
end

def create_long_format_filenames(path, filenames)
  return '' if path.empty?

  is_symlink_or_not_directory = !File.directory?(path) || File.symlink?(path)
  total, long_format_table = create_total_and_long_format_table(path, filenames, is_symlink_or_not_directory)
  if is_symlink_or_not_directory
    long_format_table
  elsif filenames.empty?
    total
  else
    total + long_format_table
  end
end

def create_total_and_long_format_table(path, filenames, is_symlink_or_not_directory)
  total_block, processing_table = create_processing_table(path, filenames, is_symlink_or_not_directory)
  column_widths = [0, 0, 0, 0, 0, 0, 0]
  processing_table.each do |row|
    row.each_with_index do |field, i|
      width = field.length
      column_widths[i] = [column_widths[i], width].max
    end
  end
  total = "total #{total_block}\n"
  long_format_table = create_long_format_table(processing_table, column_widths)
  [total, long_format_table]
end

def create_processing_table(path, filenames, is_symlink_or_not_directory)
  total_block = 0
  filenames = [path] if is_symlink_or_not_directory
  processing_table = filenames.map do |filename|
    filepath = is_symlink_or_not_directory ? filename : "#{path}/#{filename}"
    stat = File.lstat(filepath)
    total_block += stat.blocks
    size_or_rdev = [FTYPE_BLOCK_SPECIAL, FTYPE_CHARACTER_SPECIAL].include?(stat.ftype) ? "0x#{stat.rdev.to_s(16)}" : stat.size.to_s
    [
      create_mode(stat.ftype, stat.mode),
      stat.nlink.to_s,
      Etc.getpwuid(stat.uid).name,
      Etc.getgrgid(stat.gid).name,
      size_or_rdev,
      stat.mtime.strftime('%b %e %H:%M'),
      stat.ftype == FTYPE_LINK ? "#{filename} -> #{File.readlink(filepath)}" : filename
    ]
  end
  [total_block, processing_table]
end

def create_mode(ftype, mode)
  rwx_mode = create_rwx_mode(mode)
  case ftype
  when FTYPE_BLOCK_SPECIAL then "b#{rwx_mode}"
  when FTYPE_CHARACTER_SPECIAL then "c#{rwx_mode}"
  when FTYPE_DIRECTORY then "d#{rwx_mode}"
  when FTYPE_LINK then "l#{rwx_mode}"
  when FTYPE_FIFO then "p#{rwx_mode}"
  when FTYPE_SOCKET then "s#{rwx_mode}"
  else "-#{rwx_mode}" # macのls -lでは'whiteout'があるが、ftypeには含まれず、'unknown'などの場合は'file'としておくため
  end
end

def create_rwx_mode(mode)
  rwx_octal_chars = mode.to_s(8)[-3..]
  rwx_octal_chars.chars.map do |octal_char|
    OCTAL_CHAR_TO_RWX[octal_char]
  end.join
end

def create_long_format_table(processing_table, column_widths)
  processing_table.map do |row|
    row.each_with_index.map do |field, i|
      if [0, 6].include?(i)
        field
      elsif i == 2
        "#{field.ljust(column_widths[i])} "
      elsif i == 3
        field.ljust(column_widths[i])
      else
        field.rjust(column_widths[i])
      end
    end.join(' ')
  end.join("\n").concat("\n")
end

def create_filenames(filenames)
  return '' if filenames.empty?

  ljust_width = 0
  each_filename_full_width_counts = filenames.map do |filename|
    full_width_count = filename.scan(FULL_WIDTH_REGEX).count # 全角文字は2文字としてカウントするため
    width = filename.length + full_width_count + WHITESPACE_BETWEEN_FILENAMES
    ljust_width = [width, ljust_width].max
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
