#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require_relative '../ls'

class FullWidthTest < Minitest::Test
  SAMPLE_DIR = 'test/sample'

  def setup
    FileUtils.mkdir_p(SAMPLE_DIR)
    Dir.chdir(SAMPLE_DIR) do
      entries = %w[
        Gemfile Gemfile.lock Procfile README.md babel.config.js
        bin config config.ru log package.json postcss.config.js
        漢字のファイル.txt
      ]
      entries.each { |entry| FileUtils.touch(entry) }
    end
  end

  def teardown
    FileUtils.rm_rf(SAMPLE_DIR)
  end

  def test_full_width
    expected =
      "Gemfile             babel.config.js     log                 \n" \
      "Gemfile.lock        bin                 package.json        \n" \
      "Procfile            config              postcss.config.js   \n" \
      "README.md           config.ru           漢字のファイル.txt  \n"

    Dir.chdir(SAMPLE_DIR) do
      assert_equal expected, LsCommand.exec
    end
  end
end
