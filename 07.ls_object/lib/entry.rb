# frozen_string_literal: true

require_relative 'entry_status'
require_relative 'common_entry_methods'

class Entry
  include CommonEntryMethods

  FULL_WIDTH_REGEX = /[^ -~｡-ﾟ]/
  DISPLAYED_COLUMN = 3
  MARGIN_BETWEEN_ENTRIES = 2

  attr_reader :path, :parent_path, :is_parent, :path_full_width_count, :path_width, :not_exist, :status

  def initialize(path, parent_path = nil, is_parent: true)
    @path = path
    @parent_path = parent_path
    @is_parent = is_parent
    @path_full_width_count = @path.scan(FULL_WIDTH_REGEX).count
    @path_width = @path.length + @path_full_width_count
    @not_exist = !(File.exist?(absolute_path) || File.symlink?(absolute_path))
    return if @not_exist

    @status = EntryStatus.new(absolute_path)
    @child_entries = @is_parent ? create_child_entries : []
  end

  def not_directory?
    !directory?
  end

  def format
    return "ls: #{@path}: No such file or directory" if @not_exist

    if not_directory?
      LsCommand.option_l? ? format_status_with_l_option : @path
    else
      formatted_child_entries = LsCommand.option_l? ? format_with_l_option : format_without_l_option
      formatted_child_entries = "#{@path}:\n#{formatted_child_entries}" if LsCommand.two_or_more_paths?
      formatted_child_entries
    end
  end

  def absolute_path
    @is_parent ? @path : "#{@parent_path}/#{@path}"
  end

  private

  def directory?
    if LsCommand.option_l?
      @status.directory?
    else
      @status.directory? || @status.symlink?
    end
  end

  def create_child_entries
    child_entry_paths =
      if LsCommand.option_a? && directory?
        Dir.entries(@path).sort # ..の表示を含めるためentriesを使用
      else
        Dir.glob('*', base: @path).sort
      end
    child_entry_paths.reverse! if LsCommand.option_r?
    child_entry_paths.map { |child_entry_path| Entry.new(child_entry_path, @path, is_parent: false) }
  end

  def format_without_l_option
    return '' if @child_entries.empty?

    max_path_width = @child_entries.map(&:path_width).max
    column = @child_entries.length.ceildiv(DISPLAYED_COLUMN)
    sliced_child_entries = @child_entries.each_slice(column).to_a
    nil_count_for_transpose = column - sliced_child_entries[-1].length
    nil_count_for_transpose.times { sliced_child_entries[-1] << nil }

    sliced_child_entries.transpose.map do |row|
      row.map do |child_entry|
        next if child_entry.nil?

        ljust_width = max_path_width - child_entry.path_full_width_count + MARGIN_BETWEEN_ENTRIES
        child_entry.path.ljust(ljust_width)
      end.join
    end.join("\n").concat("\n")
  end

  def format_with_l_option
    total_block = @child_entries.sum { |child_entry| child_entry.status.block }
    total = "total #{total_block}\n"
    formatted_child_entry_statuses =
      if @child_entries.empty?
        ''
      else
        update_max_widths(@child_entries)
        @child_entries.map do |child_entry|
          format_status_with_l_option(child_entry)
        end.join("\n").concat("\n")
      end
    total + formatted_child_entry_statuses
  end

  def format_status_with_l_option(entry = self)
    entry.status.format(entry.path, entry.absolute_path)
  end
end
