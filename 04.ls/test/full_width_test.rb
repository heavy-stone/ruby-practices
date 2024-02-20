#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_full_width
    filenames = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
      漢字のファイル.txt
    ]
    expected =
      "Gemfile             babel.config.js     log                 \n" \
      "Gemfile.lock        bin                 package.json        \n" \
      "Procfile            config              postcss.config.js   \n" \
      "README.md           config.ru           漢字のファイル.txt  \n"
    Dir.stub(:glob, filenames) do
      assert_equal expected, ls({})
    end
  end
end
