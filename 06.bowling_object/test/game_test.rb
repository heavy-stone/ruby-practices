#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../game'

class GameTest < Minitest::Test
  def test_score1
    arg_score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'
    game = Game.new(arg_score)
    assert_equal 139, game.score
  end

  def test_score2
    arg_score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'
    game = Game.new(arg_score)
    assert_equal 164, game.score
  end

  def test_score3
    arg_score = '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'
    game = Game.new(arg_score)
    assert_equal 107, game.score
  end

  def test_score4
    arg_score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'
    game = Game.new(arg_score)
    assert_equal 134, game.score
  end

  def test_score5
    arg_score = '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8'
    game = Game.new(arg_score)
    assert_equal 144, game.score
  end

  def test_score6
    arg_score = 'X,X,X,X,X,X,X,X,X,X,X,X'
    game = Game.new(arg_score)
    assert_equal 300, game.score
  end

  def test_score7
    arg_score = 'X,X,X,X,X,X,X,X,X,X,X,2'
    game = Game.new(arg_score)
    assert_equal 292, game.score
  end

  def test_score8
    arg_score = 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0'
    game = Game.new(arg_score)
    assert_equal 50, game.score
  end
end
