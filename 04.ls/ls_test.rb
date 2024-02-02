#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls'

class LsTest < Minitest::Test
  def test_number_file_names
    input_file_names = [*'1'..'10']
    expected =
      "1   4   8   \n" \
      "10  5   9   \n" \
      "2   6       \n" \
      "3   7       \n"
    assert_equal expected, ls(input_file_names)
  end

  def test_file_names
    input_file_names = [
      'Gemfile',
      'Gemfile.lock',
      'Procfile',
      'README.md',
      'babel.config.js',
      'bin',
      'config',
      'config.ru',
      'log',
      'package.json',
      'postcss.config.js'
    ]
    expected =
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      "README.md          config.ru                             \n"
    assert_equal expected, ls(input_file_names)
  end
end
