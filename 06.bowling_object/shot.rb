# frozen_string_literal: true

require_relative 'constants'

class Shot
  attr_reader :score

  def initialize(score)
    raise ArgumentError, "引数には#{ZERO_SCORE}~#{STRIKE_SCORE}の数値み指定してください" unless (ZERO_SCORE..STRIKE_SCORE).cover?(score)

    @score = score
  end
end
