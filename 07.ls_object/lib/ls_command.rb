# frozen_string_literal: true

require 'optparse'
require_relative './entry_manager'

class LsCommand
  NO_OPTIONS = { a: false, l: false, r: false }.freeze

  def self.exec(options = NO_OPTIONS, paths = [Ls::CURRENT_DIRECTORY])
    @options = options
    @has_two_or_more_path = paths.length >= 2
    EntryManager.format_entries(paths)
  end

  def self.option_a?
    @options['a']
  end

  def self.option_l?
    @options['l']
  end

  def self.option_r?
    @options['r']
  end

  def self.two_or_more_paths?
    @has_two_or_more_path
  end
end
