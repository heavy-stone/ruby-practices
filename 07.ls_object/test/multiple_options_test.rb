#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class MultipleOptionsTest < Minitest::Test
  def test_al_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected = <<~TEXT
      brw-r-----  1 root  operator  0x1000004 May  7 10:15 /dev/disk1
      crw-rw-rw-  1 root  wheel     0x3000003 May  7 10:15 /dev/zero

      /usr:
      total 0
      drwxr-xr-x   11 root  wheel    352 Mar 21 15:13 .
      drwxr-xr-x   20 root  wheel    640 Mar 21 15:13 ..
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

    assert_equal expected, LsCommand.exec({ 'a' => true, 'l' => true }, paths)
  end

  def test_ar_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected =
      "/dev/zero  /dev/disk1\n" \
      "\n" \
      "/usr:\n" \
      "standalone  libexec     X11         \n" \
      "share       lib         ..          \n" \
      "sbin        bin         .           \n" \
      "local       X11R6       \n"

    assert_equal expected, LsCommand.exec({ 'a' => true, 'r' => true }, paths)
  end

  def test_rl_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected = <<~TEXT
      crw-rw-rw-  1 root  wheel     0x3000003 May  7 10:15 /dev/zero
      brw-r-----  1 root  operator  0x1000004 May  7 10:15 /dev/disk1

      /usr:
      total 0
      drwxr-xr-x    5 root  wheel    160 Mar 21 15:13 standalone
      drwxr-xr-x   42 root  wheel   1344 Mar 21 15:13 share
      drwxr-xr-x  230 root  wheel   7360 Mar 21 15:13 sbin
      drwxr-xr-x    3 root  wheel     96 May  7 10:16 local
      drwxr-xr-x  362 root  wheel  11584 Mar 21 15:13 libexec
      drwxr-xr-x   32 root  wheel   1024 Mar 21 15:13 lib
      drwxr-xr-x  984 root  wheel  31488 Mar 21 15:13 bin
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11R6 -> ../private/var/select/X11
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11 -> ../private/var/select/X11
    TEXT

    assert_equal expected, LsCommand.exec({ 'r' => true, 'l' => true }, paths)
  end

  def test_arl_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected = <<~TEXT
      crw-rw-rw-  1 root  wheel     0x3000003 May  7 10:15 /dev/zero
      brw-r-----  1 root  operator  0x1000004 May  7 10:15 /dev/disk1

      /usr:
      total 0
      drwxr-xr-x    5 root  wheel    160 Mar 21 15:13 standalone
      drwxr-xr-x   42 root  wheel   1344 Mar 21 15:13 share
      drwxr-xr-x  230 root  wheel   7360 Mar 21 15:13 sbin
      drwxr-xr-x    3 root  wheel     96 May  7 10:16 local
      drwxr-xr-x  362 root  wheel  11584 Mar 21 15:13 libexec
      drwxr-xr-x   32 root  wheel   1024 Mar 21 15:13 lib
      drwxr-xr-x  984 root  wheel  31488 Mar 21 15:13 bin
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11R6 -> ../private/var/select/X11
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11 -> ../private/var/select/X11
      drwxr-xr-x   20 root  wheel    640 Mar 21 15:13 ..
      drwxr-xr-x   11 root  wheel    352 Mar 21 15:13 .
    TEXT

    assert_equal expected, LsCommand.exec({ 'a' => true, 'r' => true, 'l' => true }, paths)
  end

  def test_arl_options_with_multiple_paths_with_error_entries
    paths = %w[/no_exist1 /no_exist2 /tmp /usr]
    expected = <<~TEXT
      ls: /no_exist1: No such file or directory
      ls: /no_exist2: No such file or directory
      lrwxr-xr-x  1 root  wheel  11 Mar 21 15:13 /tmp -> private/tmp

      /usr:
      total 0
      drwxr-xr-x    5 root  wheel    160 Mar 21 15:13 standalone
      drwxr-xr-x   42 root  wheel   1344 Mar 21 15:13 share
      drwxr-xr-x  230 root  wheel   7360 Mar 21 15:13 sbin
      drwxr-xr-x    3 root  wheel     96 May  7 10:16 local
      drwxr-xr-x  362 root  wheel  11584 Mar 21 15:13 libexec
      drwxr-xr-x   32 root  wheel   1024 Mar 21 15:13 lib
      drwxr-xr-x  984 root  wheel  31488 Mar 21 15:13 bin
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11R6 -> ../private/var/select/X11
      lrwxr-xr-x    1 root  wheel     25 Mar 21 15:13 X11 -> ../private/var/select/X11
      drwxr-xr-x   20 root  wheel    640 Mar 21 15:13 ..
      drwxr-xr-x   11 root  wheel    352 Mar 21 15:13 .
    TEXT

    assert_equal expected, LsCommand.exec({ 'a' => true, 'r' => true, 'l' => true }, paths)
  end
end
