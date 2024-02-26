#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  # test_l_optionはFile.lstatのstub化が難しいため除外
  def test_l_option_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected_output = <<~TEXT
      brw-r----- 1 root  operator 0x1000004 Feb 23 21:55 /dev/disk1
      crw-rw-rw- 1 root  wheel 0x3000003 Feb 23 21:55 /dev/zero

    TEXT
    expected = <<~TEXT
      /usr:
      total 0
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11 -> ../private/var/select/X11
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11R6 -> ../private/var/select/X11
      drwxr-xr-x 982 root  wheel 31424 Dec 15 23:43 bin
      drwxr-xr-x  32 root  wheel  1024 Dec 15 23:43 lib
      drwxr-xr-x 358 root  wheel 11456 Dec 15 23:43 libexec
      drwxr-xr-x   3 root  wheel    96 Dec 28 18:59 local
      drwxr-xr-x 230 root  wheel  7360 Dec 15 23:43 sbin
      drwxr-xr-x  42 root  wheel  1344 Dec 15 23:43 share
      drwxr-xr-x   5 root  wheel   160 Dec 15 23:43 standalone
    TEXT
    assert_output(expected_output, '') do
      assert_equal expected, ls({ 'l' => true }, paths)
    end
  end
end
