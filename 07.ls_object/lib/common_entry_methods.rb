# frozen_string_literal: true

module CommonEntryMethods
  def update_max_widths(entries)
    max_nlink_width = entries.map { |entry| entry.status.nlink.length }.max
    max_uid_width = entries.map { |entry| entry.status.uid.length }.max
    max_gid_width = entries.map { |entry| entry.status.gid.length }.max
    max_size_or_rdev_width = entries.map { |entry| entry.status.size_or_rdev.length }.max
    entries.each do |entry|
      entry.status.update_max_width(max_nlink_width, max_uid_width, max_gid_width, max_size_or_rdev_width)
    end
  end
end
