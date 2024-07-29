# frozen_string_literal: true

require_relative 'entry'
require_relative 'common_entry_methods'

class EntryManager
  include CommonEntryMethods

  def self.create_with_data(paths)
    new(paths)
  end

  def initialize(paths)
    sorted_paths = paths.sort
    @entries = sorted_paths.map { |path| Entry.new(path) }
  end

  def output
    error_entries, valid_entries = @entries.partition(&:not_exist)
    not_directory_entries, directory_entries = valid_entries.partition(&:not_directory?)
    has_not_directory_and_directory_entries = !not_directory_entries.empty? && !directory_entries.empty?

    not_directory_entries.reverse! if LsCommand.option_r?
    directory_entries.reverse! if LsCommand.option_r?

    [
      format_to_error_line(error_entries),
      format_to_not_directory_line(not_directory_entries),
      has_not_directory_and_directory_entries ? "\n" : '',
      format_to_directory_line(directory_entries)
    ].join
  end

  private

  def format_to_error_line(error_entries)
    return '' if error_entries.empty?

    error_entries.map(&:format).join("\n").concat("\n")
  end

  def format_to_not_directory_line(not_directory_entries)
    return '' if not_directory_entries.empty?

    if LsCommand.option_l?
      update_max_widths(not_directory_entries)
      not_directory_entries.map(&:format).join("\n").concat("\n")
    else
      not_directory_entries.map(&:format).join(' ' * Entry::MARGIN_BETWEEN_ENTRIES).concat("\n")
    end
  end

  def format_to_directory_line(directory_entries)
    return '' if directory_entries.empty?

    directory_entries.map(&:format).join("\n")
  end
end
