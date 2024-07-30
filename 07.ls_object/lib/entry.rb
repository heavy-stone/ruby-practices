# frozen_string_literal: true

require_relative 'entry_status'

class Entry
  FULL_WIDTH_REGEX = /[^ -~｡-ﾟ]/
  private_constant :FULL_WIDTH_REGEX

  attr_reader :path, :path_full_width_count, :path_width, :status

  def initialize(path, group_type, parent_path = nil)
    @path = path
    @group_type = group_type
    @parent_path = parent_path
    @path_full_width_count = @path.scan(FULL_WIDTH_REGEX).count
    @path_width = @path.length + @path_full_width_count
    return if @group_type == EntryManager::ENTRY_GROUP_TYPE[:error]

    @status = EntryStatus.new(absolute_path)
  end

  def format_error
    "ls: #{@path}: No such file or directory"
  end

  def format_status_with_l_option(max_widths)
    @status.format(@path, absolute_path, max_widths)
  end

  private

  def absolute_path
    @parent_path.nil? ? @path : "#{@parent_path}/#{@path}"
  end
end
