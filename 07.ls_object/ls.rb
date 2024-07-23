#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './lib/ls_command'

class Ls
  CURRENT_DIRECTORY = '.'
  OPTIONS = 'alr'
  private_constant :OPTIONS

  def self.main
    options = ARGV.getopts(OPTIONS)
    paths = ARGV.empty? ? [CURRENT_DIRECTORY] : ARGV
    print LsCommand.exec(options, paths)
  end
end

Ls.main if $PROGRAM_NAME == __FILE__
