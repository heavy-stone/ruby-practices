# frozen_string_literal: true

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
    first_score + second_score + (@third_shot&.score || 0)
  end

  def strike?
    first_score == 10
  end

  def spare?
    first_score < 10 && score == 10
  end

  private

  def validate_initialize(first_shot, second_shot, third_shot)
    frame_score = first_shot.score + second_shot.score
    is_not_last_frame = third_shot.nil?
    valid =
      if is_not_last_frame
        frame_score <= 10
      else
        last_frame_score = frame_score + third_shot.score
        frame_score <= 20 && last_frame_score <= 30
      end
    raise ArgumentError, '引数が持つスコア値が適切ではありません' unless valid
  end
end
