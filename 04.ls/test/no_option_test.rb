#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_no_option_number_filenames
    filenames = [*'1'..'10']
    expected =
      "1   4   8   \n" \
      "10  5   9   \n" \
      "2   6       \n" \
      "3   7       \n"
    Dir.stub(:glob, filenames) do
      assert_equal expected, ls({ 'a' => false })
    end
  end

  def test_no_option
    filenames = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      "README.md          config.ru                             \n"
    Dir.stub(:glob, filenames) do
      assert_equal expected, ls({ 'a' => false })
    end
  end
end
