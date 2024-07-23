#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class AOptionTest < Minitest::Test
  def test_a_option
    entries = %w[
      . .. Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      ".                  README.md          log                \n" \
      "..                 babel.config.js    package.json       \n" \
      "Gemfile            bin                postcss.config.js  \n" \
      "Gemfile.lock       config             \n" \
      "Procfile           config.ru          \n"

    Dir.stub(:entries, entries) do
      assert_equal expected, LsCommand.exec({ 'a' => true })
    end
  end
end
