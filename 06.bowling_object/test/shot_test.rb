#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../shot'

class ShotTest < Minitest::Test
  def test_initialize_of_minus1
    assert_raises ArgumentError, '引数には0~10の数値み指定してください' do
      Shot.new(-1)
    end
  end

  def test_initialize_of_over10
    assert_raises ArgumentError, '引数には0~10の数値み指定してください' do
      Shot.new(11)
    end
  end

  def test_score0
    shot = Shot.new(0)
    assert_equal 0, shot.score
  end

  def test_score10
    shot = Shot.new(10)
    assert_equal 10, shot.score
  end
end
