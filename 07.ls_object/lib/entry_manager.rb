# frozen_string_literal: true

require_relative 'entry_group'

class EntryManager
  def self.format_entry_groups(paths, option_handler)
    sorted_paths = paths.sort
    valid_paths, error_paths = sorted_paths.partition { |path| File.exist?(path) || File.symlink?(path) }
    directory_paths, not_directory_paths = valid_paths.partition { |path| directory?(path, option_handler) }

    reverse_paths_if_needed!(not_directory_paths, directory_paths, option_handler)
    has_not_directory_and_directory = !not_directory_paths.empty? && !directory_paths.empty?

    error_entry_group = EntryGroup.new(error_paths, EntryGroup::TYPES[:error], option_handler)
    not_directory_entry_group = EntryGroup.new(not_directory_paths, EntryGroup::TYPES[:not_directory], option_handler)
    directory_entry_groups = create_directory_entry_groups(directory_paths, option_handler)

    [
      error_entry_group.format_entry_group,
      not_directory_entry_group.format_entry_group,
      has_not_directory_and_directory ? "\n" : '',
      directory_entry_groups.map(&:format_entry_group).join("\n")
    ].join
  end

  def self.directory?(path, option_handler)
    if option_handler.option_l?
      File.directory?(path) && !File.symlink?(path)
    else
      File.directory?(path)
    end
  end

  def self.reverse_paths_if_needed!(not_directory_paths, directory_paths, option_handler)
    return if !option_handler.option_r?

    not_directory_paths.reverse!
    directory_paths.reverse!
  end

  def self.create_directory_entry_groups(directory_paths, option_handler)
    return [] if directory_paths.empty?

    directory_paths.map do |directory_path|
      entry_paths =
        if option_handler.option_a? && directory?(directory_path, option_handler)
          Dir.entries(directory_path).sort # ..の表示を含めるためentriesを使用
        else
          Dir.glob('*', base: directory_path).sort
        end
      entry_paths.reverse! if option_handler.option_r?
      EntryGroup.new(entry_paths, EntryGroup::TYPES[:directory], option_handler, directory_path)
    end
  end

  private_class_method :directory?, :reverse_paths_if_needed!, :create_directory_entry_groups
end
