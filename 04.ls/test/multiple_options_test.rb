#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  # test_al_optionsはFile.lstatのstub化が難しいため除外
  def test_al_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected_stdout = <<~TEXT
      brw-r----- 1 root  operator 0x1000004 Mar  4 17:43 /dev/disk1
      crw-rw-rw- 1 root  wheel 0x3000003 Mar  4 17:43 /dev/zero

    TEXT
    expected = <<~TEXT
      /usr:
      total 0
      drwxr-xr-x  11 root  wheel   352 Dec 15 23:43 .
      drwxr-xr-x  20 root  wheel   640 Dec 15 23:43 ..
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
    assert_output(expected_stdout, '') do
      assert_equal expected, ls({ 'a' => true, 'l' => true }, paths)
    end
  end

  def test_ar_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected_stdout = "/dev/zero /dev/disk1\n\n"
    expected =
      "/usr:\n" \
      "standalone  libexec     X11         \n" \
      "share       lib         ..          \n" \
      "sbin        bin         .           \n" \
      "local       X11R6                   \n"
    assert_output(expected_stdout, '') do
      assert_equal expected, ls({ 'a' => true, 'r' => true }, paths)
    end
  end

  def test_rl_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected_stdout = <<~TEXT
      crw-rw-rw- 1 root  wheel 0x3000003 Mar  4 17:43 /dev/zero
      brw-r----- 1 root  operator 0x1000004 Mar  4 17:43 /dev/disk1

    TEXT
    expected = <<~TEXT
      /usr:
      total 0
      drwxr-xr-x   5 root  wheel   160 Dec 15 23:43 standalone
      drwxr-xr-x  42 root  wheel  1344 Dec 15 23:43 share
      drwxr-xr-x 230 root  wheel  7360 Dec 15 23:43 sbin
      drwxr-xr-x   3 root  wheel    96 Dec 28 18:59 local
      drwxr-xr-x 358 root  wheel 11456 Dec 15 23:43 libexec
      drwxr-xr-x  32 root  wheel  1024 Dec 15 23:43 lib
      drwxr-xr-x 982 root  wheel 31424 Dec 15 23:43 bin
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11R6 -> ../private/var/select/X11
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11 -> ../private/var/select/X11
    TEXT
    assert_output(expected_stdout, '') do
      assert_equal expected, ls({ 'r' => true, 'l' => true }, paths)
    end
  end

  # test_arl_optionsはFile.lstatのstub化が難しいため除外
  def test_arl_options_with_multiple_paths
    paths = ['/usr', '/dev/disk1', '/dev/zero']
    expected_stdout = <<~TEXT
      crw-rw-rw- 1 root  wheel 0x3000003 Mar  4 17:43 /dev/zero
      brw-r----- 1 root  operator 0x1000004 Mar  4 17:43 /dev/disk1

    TEXT
    expected = <<~TEXT
      /usr:
      total 0
      drwxr-xr-x   5 root  wheel   160 Dec 15 23:43 standalone
      drwxr-xr-x  42 root  wheel  1344 Dec 15 23:43 share
      drwxr-xr-x 230 root  wheel  7360 Dec 15 23:43 sbin
      drwxr-xr-x   3 root  wheel    96 Dec 28 18:59 local
      drwxr-xr-x 358 root  wheel 11456 Dec 15 23:43 libexec
      drwxr-xr-x  32 root  wheel  1024 Dec 15 23:43 lib
      drwxr-xr-x 982 root  wheel 31424 Dec 15 23:43 bin
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11R6 -> ../private/var/select/X11
      lrwxr-xr-x   1 root  wheel    25 Dec 15 23:43 X11 -> ../private/var/select/X11
      drwxr-xr-x  20 root  wheel   640 Dec 15 23:43 ..
      drwxr-xr-x  11 root  wheel   352 Dec 15 23:43 .
    TEXT
    assert_output(expected_stdout, '') do
      assert_equal expected, ls({ 'a' => true, 'r' => true, 'l' => true }, paths)
    end
  end
end
