#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'ls'

class LsTest < Minitest::Test
  def test_no_option_number_file_names
    input_file_names = [*'1'..'10']
    expected =
      "1   4   8   \n" \
      "10  5   9   \n" \
      "2   6       \n" \
      '3   7       '
    Dir.stub(:glob, input_file_names) do
      assert_equal expected, ls({ 'a' => false })
    end
  end

  def test_no_option_file_names
    input_file_names = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      'README.md          config.ru                             '
    Dir.stub(:glob, input_file_names) do
      assert_equal expected, ls({ 'a' => false })
    end
  end

  def test_a_option_file_names
    input_file_names = %w[
      . .. Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      ".                  README.md          log                \n" \
      "..                 babel.config.js    package.json       \n" \
      "Gemfile            bin                postcss.config.js  \n" \
      "Gemfile.lock       config                                \n" \
      'Procfile           config.ru                             '
    Dir.stub(:entries, input_file_names) do
      assert_equal expected, ls({ 'a' => true })
    end
  end
end
