#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_r_option
    filenames = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      "postcss.config.js  config             Procfile           \n" \
      "package.json       bin                Gemfile.lock       \n" \
      "log                babel.config.js    Gemfile            \n" \
      "config.ru          README.md                             \n"
    Dir.stub(:glob, filenames) do
      assert_equal expected, ls({ 'r' => true })
    end
  end

  def test_r_option_with_multiple_paths
    paths = ['/etc', '/usr']
    filenames = [[*'1'..'10'].sort, %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]]
    expected =
      "/usr:\n" \
      "9   5   10  \n" \
      "8   4   1   \n" \
      "7   3       \n" \
      "6   2       \n" \
      "\n" \
      "/etc:\n" \
      "postcss.config.js  config             Procfile           \n" \
      "package.json       bin                Gemfile.lock       \n" \
      "log                babel.config.js    Gemfile            \n" \
      "config.ru          README.md                             \n"
    stub(:create_each_path_filenames, filenames) do
      assert_equal expected, ls({ 'r' => true }, paths)
    end
  end
end
