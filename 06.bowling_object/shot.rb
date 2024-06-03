# frozen_string_literal: true

class Shot
  ZERO_SCORE = 0
  STRIKE_SCORE = 10

  attr_reader :score

  def initialize(score)
    raise ArgumentError, "引数には#{ZERO_SCORE}~#{STRIKE_SCORE}の数値み指定してください" unless (ZERO_SCORE..STRIKE_SCORE).cover?(score)

    @score = score
  end
end
