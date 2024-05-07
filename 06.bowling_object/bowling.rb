#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

class Bowling
  def self.main
    arg_score = ARGV[0]
    game = Game.new(arg_score)
    puts game.score
  end
end

Bowling.main if $PROGRAM_NAME == __FILE__
