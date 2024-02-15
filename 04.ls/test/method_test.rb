#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def test_validate_paths
    # テスト端末に/etc, /usrが存在することを前提とする
    # hoge, /not_found_directoryは存在しないことを前提とする
    paths = ['hoge', '/usr', '..', '/not_found_directory', '/tmp', '.']
    expected = ['.', '..', '/tmp', '/usr']
    expected_output =
      "ls: /not_found_directory: No such file or directory\n" \
      "ls: hoge: No such file or directory\n"
    assert_output(expected_output, '') do
      assert_equal expected, validate_paths(paths)
    end
  end

  def test_no_option_each_path_filenames_method
    # テスト端末に/etc, /usrが存在することを前提とする
    paths = ['/etc', '/usr']
    expected = paths.map { |path| Dir.glob('*', base: path) }
    assert_equal expected, each_path_filenames({ 'a' => false }, paths)
  end

  def test_a_option_each_path_filenames_method
    # テスト端末に/etc, /usrが存在することを前提とする
    paths = ['/etc', '/usr']
    expected = paths.map { |path| Dir.entries(path) }
    assert_equal expected, each_path_filenames({ 'a' => true }, paths)
  end

  def test_no_path_create_output_method
    paths = [CURRENT_DIRECTORY]
    filenames = [%w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]]
    expected =
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      "README.md          config.ru                             \n"
    assert_equal expected, create_output(paths, filenames)
  end

  def test_multi_path_create_output_method
    paths = ['/etc', '/usr']
    filenames = [[*'1'..'10'], %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]]
    expected =
      "/etc:\n" \
      "1   4   8   \n" \
      "10  5   9   \n" \
      "2   6       \n" \
      "3   7       \n" \
      "\n" \
      "/usr:\n" \
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      "README.md          config.ru                             \n"
    assert_equal expected, create_output(paths, filenames)
  end

  def test_no_option_create_filenames_method
    filenames = %w[
      Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      "Gemfile            babel.config.js    log                \n" \
      "Gemfile.lock       bin                package.json       \n" \
      "Procfile           config             postcss.config.js  \n" \
      "README.md          config.ru                             \n"
    assert_equal expected, create_filenames(filenames)
  end

  def test_a_option_create_filenames_method
    filenames = %w[
      . .. Gemfile Gemfile.lock Procfile README.md babel.config.js
      bin config config.ru log package.json postcss.config.js
    ]
    expected =
      ".                  README.md          log                \n" \
      "..                 babel.config.js    package.json       \n" \
      "Gemfile            bin                postcss.config.js  \n" \
      "Gemfile.lock       config                                \n" \
      "Procfile           config.ru                             \n"
    assert_equal expected, create_filenames(filenames)
  end
end
