# frozen_string_literal: true

module CommonEntryMethods
  def calc_status_max_widths(entries)
    {
      nlink_width: entries.map { |entry| entry.status.nlink.length }.max,
      uid_width: entries.map { |entry| entry.status.uid.length }.max,
      gid_width: entries.map { |entry| entry.status.gid.length }.max,
      size_or_rdev_width: entries.map { |entry| entry.status.size_or_rdev.length }.max
    }
  end
end
