#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../ls'

class LsTest < Minitest::Test
  def setup
    @dev_disk1_stat = File.lstat('/dev/disk1') # mode=060640 (blockSpecial rw-r-----)
    @dev_zero_stat = File.lstat('/dev/zero') # mode=020666 (file crw-rw-rw-)
    @etc_paths_d_stat = File.lstat('/etc/paths.d') # mode=040755 (directory rwxr-xr-x)
    @etc_resolv_conf_stat = File.lstat('/etc/resolv.conf') # mode=0120755 (link rwxr-xr-x)
    @vpncontrol_sock_stat = File.lstat('/var/run/vpncontrol.sock') # mode=0140600 (socket rw-------)
    @etc_passwd_stat = File.lstat('/etc/passwd') # mode=0100644 (file rw-r--r--)
  end

  def test_create_rwx_mode_method
    assert_equal 'rw-r-----', create_rwx_mode(@dev_disk1_stat.mode)
    assert_equal 'rw-rw-rw-', create_rwx_mode(@dev_zero_stat.mode)
    assert_equal 'rwxr-xr-x', create_rwx_mode(@etc_paths_d_stat.mode)
    assert_equal 'rwxr-xr-x', create_rwx_mode(@etc_resolv_conf_stat.mode)
    assert_equal 'rw-------', create_rwx_mode(@vpncontrol_sock_stat.mode)
    assert_equal 'rw-r--r--', create_rwx_mode(@etc_passwd_stat.mode)
  end

  def test_create_mode_method
    assert_equal 'brw-r-----', create_mode(@dev_disk1_stat.ftype, @dev_disk1_stat.mode)
    assert_equal 'crw-rw-rw-', create_mode(@dev_zero_stat.ftype, @dev_zero_stat.mode)
    assert_equal 'drwxr-xr-x', create_mode(@etc_paths_d_stat.ftype, @etc_paths_d_stat.mode)
    assert_equal 'lrwxr-xr-x', create_mode(@etc_resolv_conf_stat.ftype, @etc_resolv_conf_stat.mode)
    assert_equal 'p---------', create_mode('fifo', 0o010000) # pの実ファイルは見つからなかったため
    assert_equal 'srw-------', create_mode(@vpncontrol_sock_stat.ftype, @vpncontrol_sock_stat.mode)
    assert_equal '-rw-r--r--', create_mode(@etc_passwd_stat.ftype, @etc_passwd_stat.mode)
  end

  def test_create_long_format_rows_method
    link_or_filenames = Dir.glob('*', base: '/usr')
    stats = []
    link_or_filenames = link_or_filenames.map do |filename|
      filepath = "/usr/#{filename}"
      stats.push(File.lstat(filepath))
      stats.last.ftype == FTYPE_LINK ? "#{filename} -> #{File.readlink(filepath)}" : filename
    end
    column_to_fields =
      {
        nlinks: [],
        users: [],
        groups: [],
        size_or_rdevs: []
      }
    column_width_to_max_width =
      {
        nlink_rjust: 0,
        user_ljust: 0,
        group_ljust: 0,
        size_or_rdev_rjust: 0
      }
    stats.each do |stat|
      column_to_fields[:nlinks].push(stat.nlink.to_s)
      column_to_fields[:users].push(Etc.getpwuid(stat.uid).name)
      column_to_fields[:groups].push(Etc.getgrgid(stat.gid).name)
      column_to_fields[:size_or_rdevs].push(stat.size.to_s)
      column_width_to_max_width[:nlink_rjust] = [column_width_to_max_width[:nlink_rjust], column_to_fields[:nlinks].last.length].max
      column_width_to_max_width[:user_ljust] = [column_width_to_max_width[:user_ljust], column_to_fields[:users].last.length].max
      column_width_to_max_width[:group_ljust] = [column_width_to_max_width[:group_ljust], column_to_fields[:groups].last.length].max
      column_width_to_max_width[:size_or_rdev_rjust] = [column_width_to_max_width[:size_or_rdev_rjust], column_to_fields[:size_or_rdevs].last.length].max
    end
    expected = <<~TEXT
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
    assert_equal expected, create_long_format_rows(stats, column_to_fields, column_width_to_max_width, link_or_filenames)
  end

  def test_create_long_format_filenames_method
    assert_equal "-r--r--r-- 1 root  wheel 3094 Dec 15 23:43 /etc/zshrc\n", create_long_format_filenames('/etc/zshrc', ['/etc/zshrc'])
    assert_equal "total 0\n", create_long_format_filenames('/cores', [])
    expected = <<~TEXT
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
    assert_equal expected, create_long_format_filenames('/usr', Dir.glob('*', base: '/usr'))
  end

  def test_l_option_create_output_method
    paths = ['/usr']
    each_path_filenames = [
      Dir.glob('*', base: '/usr').sort
    ]
    has_paths = false
    expected = <<~TEXT
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
    assert_equal expected, create_output({ 'l' => true }, paths, each_path_filenames, has_paths)
  end

  def test_filter_l_option_symlink_directory_paths_method
    paths = ['/etc', '/cores', '/usr'] # /etcはシンボリックリンク、/coresは空ディレクトリ、/usrはディレクトリを想定
    has_paths = true
    assert_output("lrwxr-xr-x 1 root  wheel 11 Dec 15 23:43 /etc -> private/etc\n\n", '') do
      assert_equal ['/cores', '/usr'], filter_l_option_symlink_directory_paths({ 'l' => true }, paths, has_paths)
    end
  end
end
