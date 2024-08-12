#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class AOptionTest < Minitest::Test
  def test_a_option
    paths = %w[/no_exist1 /no_exist2 /usr /tmp]
    expected =
      "ls: /no_exist1: No such file or directory\n" \
      "ls: /no_exist2: No such file or directory\n" \
      "/tmp:\n" \
      ".                             .s.PGSQL.5432                 com.apple.launchd.5GXuNzoPTO  \n" \
      "..                            .s.PGSQL.5432.lock            powerlog                      \n" \
      "\n" \
      "/usr:\n" \
      ".           bin         sbin        \n" \
      "..          lib         share       \n" \
      "X11         libexec     standalone  \n" \
      "X11R6       local       \n"

    assert_equal expected, LsCommand.exec({ 'a' => true }, paths)
  end
end
