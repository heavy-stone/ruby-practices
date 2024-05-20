# frozen_string_literal: true

require_relative 'constants'

class Frame
  def initialize(first_shot, second_shot, third_shot = nil)
    validate_initialize(first_shot, second_shot, third_shot)

    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def first_score
    @first_shot.score
  end

  def second_score
    @second_shot.score
  end

  def score
    first_score + second_score + (@third_shot&.score || ZERO_SCORE)
  end

  def strike?
    first_score == STRIKE_SCORE
  end

  def spare?
    first_score < STRIKE_SCORE && score == STRIKE_SCORE
  end

  private

  def validate_initialize(first_shot, second_shot, third_shot)
    frame_score = first_shot.score + second_shot.score
    is_not_last_frame = third_shot.nil?
    valid =
      if is_not_last_frame
        frame_score <= STRIKE_SCORE
      else
        last_frame_score = frame_score + third_shot.score
        frame_score <= MAX_SUM_SCORE_IN_FRAME && last_frame_score <= MAX_SUM_SCORE_IN_LAST_FRAME
      end
    raise ArgumentError, '引数が持つスコア値が適切ではありません' unless valid
  end
end
