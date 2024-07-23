#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class ROptionTest < Minitest::Test
  def test_r_option
    entries = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      "postcss.config.js  config             Procfile           \n" \
      "package.json       bin                Gemfile.lock       \n" \
      "log                babel.config.js    Gemfile            \n" \
      "config.ru          README.md          \n"

    Dir.stub(:glob, entries) do
      assert_equal expected, LsCommand.exec({ 'r' => true })
    end
  end

  def test_r_option_with_multiple_paths
    mock = Minitest::Mock.new
    first_entries = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    second_entries = [*'1'..'10'].sort
    mock.expect(:call, first_entries, ['*', { base: '/etc' }])
    mock.expect(:call, second_entries, ['*', { base: '/usr' }])

    expected =
      "/usr:\n" \
      "9   5   10  \n" \
      "8   4   1   \n" \
      "7   3   \n" \
      "6   2   \n" \
      "\n" \
      "/etc:\n" \
      "postcss.config.js  config             Procfile           \n" \
      "package.json       bin                Gemfile.lock       \n" \
      "log                babel.config.js    Gemfile            \n" \
      "config.ru          README.md          \n"
    paths = ['/etc', '/usr']

    Dir.stub(:glob, ->(*args) { mock.call(*args) }) do
      assert_equal expected, LsCommand.exec({ 'r' => true }, paths)
    end
  end
end
