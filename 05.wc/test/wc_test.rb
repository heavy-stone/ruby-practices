#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative '../wc'

class WcTest < Minitest::Test
  def test_wc_with_stdin_and_no_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t5\t38\t204 \n"
    assert_equal expected, wc({ 'c' => true, 'l' => true, 'w' => true })
  end

  def test_wc_with_stdin_and_c_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t204 \n"
    assert_equal expected, wc({ 'c' => true })
  end

  def test_wc_with_stdin_and_l_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t5 \n"
    assert_equal expected, wc({ 'l' => true })
  end

  def test_wc_with_stdin_and_w_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t38 \n"
    assert_equal expected, wc({ 'w' => true })
  end

  def test_wc_with_stdin_and_cl_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t5\t204 \n"
    assert_equal expected, wc({ 'c' => true, 'l' => true })
  end

  def test_wc_with_stdin_and_cw_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t38\t204 \n"
    assert_equal expected, wc({ 'c' => true, 'w' => true })
  end

  def test_wc_with_stdin_and_lw_option
    ls_l_option_stdin = <<~TEXT
      total 24
      -rw-r--r-- 1 piyo  staff   14 Mar  7 14:45 a.txt
      -rw-r--r-- 1 piyo  staff    8 Mar  7 13:51 b.txt
      drwxr-xr-x 4 piyo  staff  128 Mar  7 19:15 test
      -rwxr--r-- 1 piyo  staff 2415 Mar  8 14:56 wc.rb
    TEXT
    $stdin = StringIO.new(ls_l_option_stdin)
    expected = "\t5\t38 \n"
    assert_equal expected, wc({ 'l' => true, 'w' => true })
  end

  def test_wc_with_file_and_no_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t73\t353\t3094 /etc/zshrc
      \t20\t 98\t 515 /etc/afpovertcp.cfg
      \t93\t451\t3609 total
    TEXT
    assert_equal expected, wc({ 'c' => true, 'l' => true, 'w' => true }, files)
  end

  def test_wc_with_file_and_c_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t3094 /etc/zshrc
      \t 515 /etc/afpovertcp.cfg
      \t3609 total
    TEXT
    assert_equal expected, wc({ 'c' => true }, files)
  end

  def test_wc_with_file_and_l_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t73 /etc/zshrc
      \t20 /etc/afpovertcp.cfg
      \t93 total
    TEXT
    assert_equal expected, wc({ 'l' => true }, files)
  end

  def test_wc_with_file_and_w_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t353 /etc/zshrc
      \t 98 /etc/afpovertcp.cfg
      \t451 total
    TEXT
    assert_equal expected, wc({ 'w' => true }, files)
  end

  def test_wc_with_file_and_cl_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t73\t3094 /etc/zshrc
      \t20\t 515 /etc/afpovertcp.cfg
      \t93\t3609 total
    TEXT
    assert_equal expected, wc({ 'c' => true, 'l' => true }, files)
  end

  def test_wc_with_file_and_cw_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t353\t3094 /etc/zshrc
      \t 98\t 515 /etc/afpovertcp.cfg
      \t451\t3609 total
    TEXT
    assert_equal expected, wc({ 'c' => true, 'w' => true }, files)
  end

  def test_wc_with_file_and_lw_option
    files = ['/etc/zshrc', '/etc/afpovertcp.cfg']
    expected = <<~TEXT
      \t73\t353 /etc/zshrc
      \t20\t 98 /etc/afpovertcp.cfg
      \t93\t451 total
    TEXT
    assert_equal expected, wc({ 'l' => true, 'w' => true }, files)
  end
end
