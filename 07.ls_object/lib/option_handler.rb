# frozen_string_literal: true

class OptionHandler
  def initialize(options, paths)
    @options = options
    @paths = paths
  end

  def option_a?
    @options['a']
  end

  def option_l?
    @options['l']
  end

  def option_r?
    @options['r']
  end

  def show_directory_name?
    @paths.length >= 2
  end
end
