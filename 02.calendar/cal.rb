#!/usr/bin/env ruby
require 'optparse'
require 'date'
require_relative 'lib/validator'
require_relative 'lib/calender'

class Cal
  include Validator
  include Calender

  def initialize
    @options = ARGV.getopts('y:m:')
  end

  def main
    validate_argv
    create
    show
  end
end

cal = Cal.new
cal.main
