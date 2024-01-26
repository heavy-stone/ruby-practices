#!/usr/bin/env ruby
# frozen_string_literal: true

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
    calender_string = create
    show(calender_string)
  end
end

cal = Cal.new
cal.main
