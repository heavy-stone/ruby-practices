#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class ROptionTest < Minitest::Test
  def test_r_option_with_multiple_paths
    paths = %w[/no_exist1 /no_exist2 /usr /tmp]
    expected =
      "ls: /no_exist1: No such file or directory\n" \
      "ls: /no_exist2: No such file or directory\n" \
      "/usr:\n" \
      "standalone  local       bin         \n" \
      "share       libexec     X11R6       \n" \
      "sbin        lib         X11         \n" \
      "\n" \
      "/tmp:\n" \
      "powerlog                      com.apple.launchd.5GXuNzoPTO  \n"

    assert_equal expected, LsCommand.exec({ 'r' => true }, paths)
  end
end
