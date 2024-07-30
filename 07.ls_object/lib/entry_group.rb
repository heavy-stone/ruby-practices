# frozen_string_literal: true

require_relative 'entry'

class EntryGroup
  DISPLAYED_COLUMN = 3
  MARGIN_BETWEEN_ENTRIES = 2
  private_constant :DISPLAYED_COLUMN, :MARGIN_BETWEEN_ENTRIES

  def initialize(paths, group_type, parent_path = nil)
    @paths = paths
    @group_type = group_type
    @parent_path = parent_path
    @entries = @paths.map { |path| Entry.new(path, @group_type, @parent_path) }
    return if @group_type == EntryManager::ENTRY_GROUP_TYPE[:error]

    @entry_status_max_widths = calc_entry_status_max_widths if !@entries.empty? && LsCommand.option_l?
  end

  def format_error_entries
    return '' if @entries.empty?

    @entries.map(&:format_error).join("\n").concat("\n")
  end

  def format_not_directory_entries
    return '' if @entries.empty?

    if LsCommand.option_l?
      format_entry_statuses_with_l_option
    else
      @paths.join(' ' * MARGIN_BETWEEN_ENTRIES).concat("\n")
    end
  end

  def format_directory_entries
    formatted_entries = LsCommand.option_l? ? format_with_l_option : format_without_l_option
    formatted_entries = "#{@parent_path}:\n#{formatted_entries}" if LsCommand.two_or_more_paths?
    formatted_entries
  end

  private

  def format_without_l_option
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

  def format_with_l_option
    total_block = @entries.sum { |entry| entry.status.block }
    total = "total #{total_block}\n"
    formatted_entry_statuses = @entries.empty? ? '' : format_entry_statuses_with_l_option
    total + formatted_entry_statuses
  end

  def format_entry_statuses_with_l_option
    @entries.map do |entry|
      entry.format_status_with_l_option(@entry_status_max_widths)
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
