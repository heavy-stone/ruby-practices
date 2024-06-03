#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'
require_relative '../frame'

class FrameTest < Minitest::Test
  def test_validate_initialize_of_argument_error
    first_shot = Shot.new(5)
    second_shot = Shot.new(6)
    assert_raises ArgumentError, '引数が持つスコア値が適切ではありません' do
      Frame.new(first_shot, second_shot)
    end
  end

  def test_score_of_strike
    first_shot = Shot.new(10)
    second_shot = Shot.new(0)
    frame = Frame.new(first_shot, second_shot)
    assert_equal 10, frame.score
  end

  def test_score_of_spare
    first_shot = Shot.new(0)
    second_shot = Shot.new(10)
    frame = Frame.new(first_shot, second_shot)
    assert_equal 10, frame.score
  end

  def test_score_of_strike_in_last_frame
    first_shot = Shot.new(10)
    second_shot = Shot.new(10)
    third_shot = Shot.new(10)
    frame = Frame.new(first_shot, second_shot, third_shot)
    assert_equal 30, frame.score
  end
end
