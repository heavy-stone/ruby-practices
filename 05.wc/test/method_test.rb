#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../wc'

class WcTest < Minitest::Test
  def test_format_output_with_all_options
    file_field_hash = { line_length: 10, word_length: 20, bytes: 30, label: 'file', error_message: '' }
    total_field_hash = { line_length: 100, word_length: 200, bytes: 300, label: 'total' }
    options = { 'c' => true, 'l' => true, 'w' => true }
    expected = "\t 10\t 20\t 30 file\n"
    assert_equal expected, format_output(file_field_hash, total_field_hash, options)
  end

  def test_format_output_with_c_option
    file_field_hash = { line_length: 10, word_length: 20, bytes: 30, label: 'file', error_message: '' }
    total_field_hash = { line_length: 100, word_length: 200, bytes: 300, label: 'total' }
    options = { 'c' => true, 'l' => false, 'w' => false }
    expected = "\t 30 file\n"
    assert_equal expected, format_output(file_field_hash, total_field_hash, options)
  end

  def test_format_output_with_l_option
    file_field_hash = { line_length: 10, word_length: 20, bytes: 30, label: 'file', error_message: '' }
    total_field_hash = { line_length: 100, word_length: 200, bytes: 300, label: 'total' }
    options = { 'c' => false, 'l' => true, 'w' => false }
    expected = "\t 10 file\n"
    assert_equal expected, format_output(file_field_hash, total_field_hash, options)
  end

  def test_format_output_with_w_option
    file_field_hash = { line_length: 10, word_length: 20, bytes: 30, label: 'file', error_message: '' }
    total_field_hash = { line_length: 100, word_length: 200, bytes: 300, label: 'total' }
    options = { 'c' => false, 'l' => false, 'w' => true }
    expected = "\t 20 file\n"
    assert_equal expected, format_output(file_field_hash, total_field_hash, options)
  end

  def test_create_output
    file_table = [
      { line_length: 1, word_length: 2, bytes: 8, label: 'b.txt', error_message: '' },
      { line_length: 4, word_length: 6, bytes: 14, label: 'a.txt', error_message: '' },
      { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: hoge: open: No such file or directory\n" },
      { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: huga: open: No such file or directory\n" }
    ]
    total_field_hash = { line_length: 5, word_length: 8, bytes: 22, label: 'total' }
    options = { 'c' => true, 'l' => true, 'w' => true }
    expected = <<~TEXT
      \t1\t2\t 8 b.txt
      \t4\t6\t14 a.txt
      wc: hoge: open: No such file or directory
      wc: huga: open: No such file or directory
      \t5\t8\t22 total
    TEXT
    assert_equal expected, create_output(file_table, total_field_hash, options)
  end

  def test_create_total_field_hash
    file_table = [
      { line_length: 1, word_length: 2, bytes: 8, label: 'b.txt', error_message: '' },
      { line_length: 4, word_length: 6, bytes: 14, label: 'a.txt', error_message: '' },
      { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: hoge: open: No such file or directory\n" },
      { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: huga: open: No such file or directory\n" }
    ]
    total_field_hash = { line_length: 5, word_length: 8, bytes: 22, label: 'total' }
    assert_equal total_field_hash, create_total_field_hash(file_table)
  end

  def test_create_file_field_hash_with_directory
    directory = '/etc'
    expected = { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: #{directory}: read: Is a directory\n" }
    assert_equal expected, create_file_field_hash(directory)
  end

  def test_create_file_field_hash_with_valid_file
    file = 'a.txt'
    expected = { line_length: 4, word_length: 6, bytes: 14, label: file, error_message: '' }
    File.stub(:exist?, true) do
      File.stub(:readlines, ["a b c\n", "d e f\n", "\n", "\n"]) do
        assert_equal(expected, create_file_field_hash(file))
      end
    end
  end

  def test_create_file_field_hash_with_invalid_file
    invalid_file = 'no_file.txt'
    expected = { line_length: 0, word_length: 0, bytes: 0, label: '', error_message: "wc: #{invalid_file}: open: No such file or directory\n" }
    File.stub(:exist?, false) do
      assert_equal(expected, create_file_field_hash(invalid_file))
    end
  end

  def test_create_file_field_hash_with_lines
    file = 'a.txt'
    lines = ["a b c\n", "d e f\n", "\n", "\n"]
    expected = { line_length: 4, word_length: 6, bytes: 14, label: file, error_message: '' }
    assert_equal(expected, create_file_field_hash_with_lines(file, lines))
  end
end
