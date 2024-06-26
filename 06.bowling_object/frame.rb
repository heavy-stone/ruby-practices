# frozen_string_literal: true

class Frame
  MAX_SUM_SCORE_IN_FRAME = Shot::STRIKE_SCORE * 2
  MAX_SUM_SCORE_IN_LAST_FRAME = Shot::STRIKE_SCORE * 3
  private_constant :MAX_SUM_SCORE_IN_FRAME, :MAX_SUM_SCORE_IN_LAST_FRAME

  attr_reader :first_shot, :second_shot

  def initialize(first_shot, second_shot, third_shot = nil)
    validate_initial_arguments(first_shot, second_shot, third_shot)

    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
  end

  def score
    @first_shot.score + @second_shot.score + (@third_shot&.score || Shot::ZERO_SCORE)
  end

  def strike?
    @first_shot.score == Shot::STRIKE_SCORE
  end

  def spare?
    @first_shot.score < Shot::STRIKE_SCORE && score == Shot::STRIKE_SCORE
  end

  private

  def validate_initial_arguments(first_shot, second_shot, third_shot)
    frame_score = first_shot.score + second_shot.score
    is_not_last_frame = third_shot.nil?
    valid =
      if is_not_last_frame
        frame_score <= Shot::STRIKE_SCORE
      else
        last_frame_score = frame_score + third_shot.score
        frame_score <= MAX_SUM_SCORE_IN_FRAME && last_frame_score <= MAX_SUM_SCORE_IN_LAST_FRAME
      end
    raise ArgumentError, '引数が持つスコア値が適切ではありません' unless valid
  end
end
