#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LOptionTest < Minitest::Test
  def test_link_entry
    paths = %w[/tmp]
    expected = "lrwxr-xr-x  1 root  wheel  11 Mar 21 15:13 /tmp -> private/tmp\n"

    assert_equal expected, LsCommand.exec({ 'l' => true }, paths)
  end

  def test_directory_entries_but_no_child_entries_with_two_or_more_paths
    paths = %w[/cores /cores]
    expected =
      "/cores:\n" \
      "total 0\n" \
      "\n" \
      "/cores:\n" \
      "total 0\n"

    assert_equal expected, LsCommand.exec({ 'l' => true }, paths)
  end

  def test_l_option_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected = <<~TEXT
      brw-r-----  1 root  operator  0x1000004 May  7 10:15 /dev/disk1
      crw-rw-rw-  1 root  wheel     0x3000003 May  7 10:15 /dev/zero

      /usr:
      total 0
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11 -> ../private/var/select/X11
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11R6 -> ../private/var/select/X11
      drwxr-xr-x  984 root  wheel  31488 Mar 21 15:13 bin
      drwxr-xr-x   32 root  wheel   1024 Mar 21 15:13 lib
      drwxr-xr-x  362 root  wheel  11584 Mar 21 15:13 libexec
      drwxr-xr-x    3 root  wheel     96 May  7 10:16 local
      drwxr-xr-x  230 root  wheel   7360 Mar 21 15:13 sbin
      drwxr-xr-x   42 root  wheel   1344 Mar 21 15:13 share
      drwxr-xr-x    5 root  wheel    160 Mar 21 15:13 standalone
    TEXT

    assert_equal expected, LsCommand.exec({ 'l' => true }, paths)
  end
end
