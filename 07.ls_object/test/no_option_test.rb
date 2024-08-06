#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'fileutils'
require_relative '../ls'

class NoOptionTest < Minitest::Test
  def test_socket_entries
    paths = %w[/dev/zero /dev/disk1]
    expected = "/dev/disk1  /dev/zero\n"

    assert_equal expected, LsCommand.exec(LsCommand::NO_OPTIONS, paths)
  end

  def test_directory_entry_but_no_child_entries
    paths = %w[/cores]
    expected = ''

    assert_equal expected, LsCommand.exec(LsCommand::NO_OPTIONS, paths)
  end

  def test_directory_entries_but_no_child_entries
    paths = %w[/cores /cores]
    expected =
      "/cores:\n" \
      "\n" \
      "/cores:\n"

    assert_equal expected, LsCommand.exec(LsCommand::NO_OPTIONS, paths)
  end

  def test_error_entry
    paths = %w[/no_exist]
    expected = 'ls: /no_exist: No such file or directory'

    assert_equal expected, LsCommand.exec(LsCommand::NO_OPTIONS, paths)
  end

  def test_error_and_and_directory_entries
    paths = %w[/no_exist1 /no_exist2 /usr /tmp]
    expected =
      "ls: /no_exist1: No such file or directory\n" \
      "ls: /no_exist2: No such file or directory\n" \
      "/tmp:\n" \
      "com.apple.launchd.5GXuNzoPTO  powerlog                      \n" \
      "\n" \
      "/usr:\n" \
      "X11         lib         sbin        \n" \
      "X11R6       libexec     share       \n" \
      "bin         local       standalone  \n" \

    assert_equal expected, LsCommand.exec(LsCommand::NO_OPTIONS, paths)
  end
end
