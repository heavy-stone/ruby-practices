# frozen_string_literal: true

require_relative 'entry'

class EntryGroup
  TYPES = {
    error: 'error',
    not_directory: 'not_directory',
    directory: 'directory'
  }.freeze
  DISPLAYED_COLUMN = 3
  MARGIN_BETWEEN_ENTRIES = 2
  private_constant :DISPLAYED_COLUMN, :MARGIN_BETWEEN_ENTRIES

  def initialize(paths, group_type, parent_path = nil, is_status_shown: false)
    @paths = paths
    @group_type = group_type
    @parent_path = parent_path
    @is_status_shown = is_status_shown
    @entries = @paths.map { |path| Entry.new(path, @group_type, @parent_path) }
    return if @group_type == TYPES[:error]

    @entry_status_max_widths = calc_entry_status_max_widths if !@entries.empty? && @is_status_shown
  end

  def format_entry_group(is_directory_name_shown: false)
    case @group_type
    when TYPES[:error]
      format_error_group
    when TYPES[:not_directory]
      format_not_directory_group
    when TYPES[:directory]
      format_directory_group(is_directory_name_shown)
    end
  end

  private

  def format_error_group
    return nil if @entries.empty?

    @entries.map(&:format_error_entry).join("\n")
  end

  def format_not_directory_group
    return nil if @entries.empty?

    if @is_status_shown
      format_entry_statuses
    else
      @paths.join(' ' * MARGIN_BETWEEN_ENTRIES).concat("\n")
    end
  end

  def format_directory_group(is_directory_name_shown)
    formatted_string = is_directory_name_shown ? "#{@parent_path}:\n" : ''
    if @is_status_shown
      total_block = @entries.sum { |entry| entry.status.block }
      formatted_string += "total #{total_block}\n"
      formatted_string += format_entry_statuses
    else
      formatted_string += format_paths
    end
    formatted_string
  end

  def format_entry_statuses
    return '' if @entries.empty?

    @entries.map do |entry|
      entry.format_status(@entry_status_max_widths)
    end.join("\n").concat("\n")
  end

  def format_paths
    return '' if @entries.empty?

    max_path_width = @entries.map(&:path_width).max
    column = @entries.length.ceildiv(DISPLAYED_COLUMN)
    sliced_entries = @entries.each_slice(column).to_a
    nil_count_for_transpose = column - sliced_entries[-1].length
    nil_count_for_transpose.times { sliced_entries[-1] << nil }

    sliced_entries.transpose.map do |row|
      row.map do |entry|
        next if entry.nil?

        ljust_width = max_path_width - entry.path_full_width_count + MARGIN_BETWEEN_ENTRIES
        entry.path.ljust(ljust_width)
      end.join
    end.join("\n").concat("\n")
  end

  def calc_entry_status_max_widths
    {
      nlink_width: @entries.map { |entry| entry.status.nlink.length }.max,
      uid_width: @entries.map { |entry| entry.status.uid.length }.max,
      gid_width: @entries.map { |entry| entry.status.gid.length }.max,
      size_or_rdev_width: @entries.map { |entry| entry.status.size_or_rdev.length }.max
    }
  end
end
