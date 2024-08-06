# frozen_string_literal: true

class OptionHandler
  def initialize(options)
    @options = options
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
end
