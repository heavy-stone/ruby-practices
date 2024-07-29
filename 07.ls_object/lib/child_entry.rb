# frozen_string_literal: true

class ChildEntry
  attr_reader :path, :parent_path, :path_full_width_count, :path_width, :status

  def initialize(path, parent_path)
    @path = path
    @parent_path = parent_path
    @path_full_width_count = @path.scan(Entry::FULL_WIDTH_REGEX).count
    @path_width = @path.length + @path_full_width_count
    return if !(File.exist?(absolute_path) || File.symlink?(absolute_path))

    @status = EntryStatus.new(absolute_path)
  end

  def format_status_with_l_option(max_widths)
    @status.format(@path, absolute_path, max_widths)
  end

  private

  def absolute_path
    "#{@parent_path}/#{@path}"
  end
end
