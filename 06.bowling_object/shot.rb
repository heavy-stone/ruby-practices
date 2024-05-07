# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(score)
    raise ArgumentError, '引数には0~10の数値み指定してください' unless (0..10).cover?(score)

    @score = score
  end
end
