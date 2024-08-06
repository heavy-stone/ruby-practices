# frozen_string_literal: true

require 'optparse'
require_relative './option_handler'
require_relative './entry_manager'

class LsCommand
  NO_OPTIONS = { a: false, l: false, r: false }.freeze

  def self.exec(options = NO_OPTIONS, paths = [Ls::CURRENT_DIRECTORY])
    option_handler = OptionHandler.new(options)
    EntryManager.format_entry_groups(paths, option_handler)
  end
end
