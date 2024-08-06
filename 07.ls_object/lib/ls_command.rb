# frozen_string_literal: true

require_relative './entry_manager'

class LsCommand
  def self.exec(options = {}, paths = [Ls::CURRENT_DIRECTORY])
    EntryManager.format_entry_groups(options, paths)
  end
end
