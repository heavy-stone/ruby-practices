#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './lib/ls_command'

class Ls
  CURRENT_DIRECTORY = '.'
  OPTION_A = 'a'
  OPTION_L = 'l'
  OPTION_R = 'r'

  OPTIONS = OPTION_A + OPTION_L + OPTION_R
  private_constant :OPTIONS

  def self.main
    options = ARGV.getopts(OPTIONS)
    paths = ARGV.empty? ? [CURRENT_DIRECTORY] : ARGV
    print LsCommand.exec(options, paths)
  end
end

Ls.main if $PROGRAM_NAME == __FILE__
