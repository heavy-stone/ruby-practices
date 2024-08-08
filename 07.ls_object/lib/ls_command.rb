# frozen_string_literal: true

require 'singleton'
require_relative 'entry_group'

class LsCommand
  include Singleton

  def self.exec(options = {}, paths = [Ls::CURRENT_DIRECTORY])
    new(options, paths).format_entry_groups
  end

  def initialize(options, paths)
    @options = options
    @paths = paths
    sorted_paths = @paths.sort
    valid_paths, @error_paths = sorted_paths.partition { |path| File.exist?(path) || File.symlink?(path) }
    @directory_paths, @not_directory_paths = valid_paths.partition { |path| directory?(path) }

    reverse_paths_if_needed!(@not_directory_paths, @directory_paths)
  end

  def format_entry_groups
    error_entry_group = EntryGroup.new(@error_paths, EntryGroup::TYPES[:error])
    not_directory_entry_group = EntryGroup.new(@not_directory_paths, EntryGroup::TYPES[:not_directory], is_status_shown: option_l?)
    directory_entry_groups = create_directory_entry_groups(@directory_paths)
    [
      error_entry_group.format_entry_group,
      not_directory_entry_group.format_entry_group,
      directory_entry_groups&.map { |entry_group| entry_group.format_entry_group(is_directory_name_shown: directory_name_shown?) }
    ].compact.join("\n")
  end

  private

  def directory_name_shown?
    @paths.length >= 2
  end

  def option_a?
    @options[Ls::OPTION_A]
  end

  def option_l?
    @options[Ls::OPTION_L]
  end

  def option_r?
    @options[Ls::OPTION_R]
  end

  def directory?(path)
    if option_l?
      File.directory?(path) && !File.symlink?(path)
    else
      File.directory?(path)
    end
  end

  def reverse_paths_if_needed!(not_directory_paths, directory_paths)
    return if !option_r?

    not_directory_paths.reverse!
    directory_paths.reverse!
  end

  def create_directory_entry_groups(directory_paths)
    return nil if directory_paths.empty?

    directory_paths.map do |directory_path|
      entry_paths =
        if option_a? && directory?(directory_path)
          Dir.entries(directory_path).sort # ..の表示を含めるためentriesを使用
        else
          Dir.glob('*', base: directory_path).sort
        end
      entry_paths.reverse! if option_r?
      EntryGroup.new(entry_paths, EntryGroup::TYPES[:directory], directory_path, is_status_shown: option_l?)
    end
  end
end
