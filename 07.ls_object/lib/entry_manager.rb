# frozen_string_literal: true

require_relative 'entry_group'

class EntryManager
  ENTRY_GROUP_TYPE = {
    error: 'error',
    not_directory: 'not_directory',
    directory: 'directory'
  }.freeze

  def self.format_entry_groups(paths)
    sorted_paths = paths.sort
    valid_paths, error_paths = sorted_paths.partition { |path| File.exist?(path) || File.symlink?(path) }
    directory_paths, not_directory_paths = valid_paths.partition { |path| directory?(path) }

    reverse_paths_if_needed!(not_directory_paths, directory_paths)
    has_not_directory_and_directory = !not_directory_paths.empty? && !directory_paths.empty?

    error_entry_group = EntryGroup.new(error_paths, ENTRY_GROUP_TYPE[:error])
    not_directory_entry_group = EntryGroup.new(not_directory_paths, ENTRY_GROUP_TYPE[:not_directory])
    directory_entry_groups = create_directory_entry_groups(directory_paths)

    [
      error_entry_group.format_error_entries,
      not_directory_entry_group.format_not_directory_entries,
      has_not_directory_and_directory ? "\n" : '',
      directory_entry_groups.map(&:format_directory_entries).join("\n")
    ].join
  end

  def self.directory?(path)
    if LsCommand.option_l?
      File.directory?(path) && !File.symlink?(path)
    else
      File.directory?(path)
    end
  end

  def self.reverse_paths_if_needed!(not_directory_paths, directory_paths)
    return if !LsCommand.option_r?

    not_directory_paths.reverse!
    directory_paths.reverse!
  end

  def self.create_directory_entry_groups(directory_paths)
    return [] if directory_paths.empty?

    directory_paths.map do |directory_path|
      entry_paths =
        if LsCommand.option_a? && directory?(directory_path)
          Dir.entries(directory_path).sort # ..の表示を含めるためentriesを使用
        else
          Dir.glob('*', base: directory_path).sort
        end
      entry_paths.reverse! if LsCommand.option_r?
      EntryGroup.new(entry_paths, ENTRY_GROUP_TYPE[:directory], directory_path)
    end
  end

  private_class_method :directory?, :reverse_paths_if_needed!, :create_directory_entry_groups
end
