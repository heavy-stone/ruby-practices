# frozen_string_literal: true

require 'etc'

class EntryStatus
  FTYPE_BLOCK_SPECIAL = 'blockSpecial'
  FTYPE_CHARACTER_SPECIAL = 'characterSpecial'
  FTYPE_DIRECTORY = 'directory'
  FTYPE_LINK = 'link'
  FTYPE_FIFO = 'fifo'
  FTYPE_SOCKET = 'socket'
  FTYPES = {
    FTYPE_BLOCK_SPECIAL => 'b',
    FTYPE_CHARACTER_SPECIAL => 'c',
    FTYPE_DIRECTORY => 'd',
    FTYPE_LINK => 'l',
    FTYPE_FIFO => 'p',
    FTYPE_SOCKET => 's'
  }.freeze
  OCTAL_CHAR_TO_RWX = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  attr_reader :block, :nlink, :uid, :gid, :size_or_rdev
  binding.irb

  def initialize(path)
    stat = File.lstat(path)
    @block = stat.blocks
    @mode = format_mode(stat.ftype, stat.mode)
    @nlink = stat.nlink.to_s
    @uid = Etc.getpwuid(stat.uid).name
    @gid = Etc.getgrgid(stat.gid).name
    @size_or_rdev = [FTYPE_BLOCK_SPECIAL, FTYPE_CHARACTER_SPECIAL].include?(stat.ftype) ? "0x#{stat.rdev.to_s(16)}" : stat.size.to_s
    @mtime = stat.mtime.strftime('%b %e %H:%M')
    @ftype = stat.ftype
    @max_nlink_width = @nlink.length
    @max_uid_width = @uid.length
    @max_gid_width = @gid.length
    @max_size_or_rdev_width = @size_or_rdev.length
  end

  def directory?
    @ftype == FTYPE_DIRECTORY
  end

  def symlink?
    @ftype == FTYPE_LINK
  end

  def format(path, absolute_path, max_widths)
    [
      "#{@mode} ",
      @nlink.rjust(max_widths[:nlink_width]),
      "#{@uid.ljust(max_widths[:uid_width])} ",
      "#{@gid.ljust(max_widths[:gid_width])} ",
      @size_or_rdev.rjust(max_widths[:size_or_rdev_width]),
      @mtime,
      symlink? ? "#{path} -> #{File.readlink(absolute_path)}" : path
    ].join(' ')
  end

  private

  def format_mode(ftype, mode)
    rwx_mode = format_to_rwx_mode(mode)
    "#{FTYPES[ftype] || '-'}#{rwx_mode}" # macのls -lでは'whiteout'があるが、ftypeには含まれず、'unknown'などの場合は'file'(-)としておく
  end

  def format_to_rwx_mode(mode)
    rwx_octal_chars = mode.to_s(8)[-3..]
    rwx_octal_chars.chars.map do |octal_char|
      OCTAL_CHAR_TO_RWX[octal_char]
    end.join
  end
end
