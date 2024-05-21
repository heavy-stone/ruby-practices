# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  LAST_FRAME = 9
  SECOND_FRAME_FROM_THE_LAST = LAST_FRAME - 1
  private_constant :LAST_FRAME, :SECOND_FRAME_FROM_THE_LAST

  def initialize(scores)
    shots = to_shots(scores)
    frame_shots = to_frame_shots(shots)
    @frames = frame_shots.map { |frame_shot| Frame.new(*frame_shot) }
  end

  def score
    present_score = 0
    @frames.each_with_index do |frame, index|
      present_score += frame.score
      present_score += bonus_score(@frames, frame, index)
    end
    present_score
  end

  private

  def to_shots(scores)
    shots = []
    scores.split(',').each do |shot|
      if shot == 'X'
        shots << Shot.new(Shot::STRIKE_SCORE)
        shots << Shot.new(Shot::ZERO_SCORE)
      else
        shots << Shot.new(shot.to_i)
      end
    end
    shots
  end

  def to_frame_shots(shots)
    frame_shots = []
    shots.each_slice(2).with_index(0) do |sliced_shots, index|
      if index < LAST_FRAME
        frame_shots << sliced_shots
      elsif index == LAST_FRAME
        sliced_shots.pop if sliced_shots[0].score == Shot::STRIKE_SCORE
        frame_shots << sliced_shots
      elsif index > LAST_FRAME
        sliced_shots.pop if sliced_shots[0].score == Shot::STRIKE_SCORE
        frame_shots.last.push(*sliced_shots)
      end
    end
    frame_shots
  end

  def bonus_score(frames, frame, index)
    if frame.strike? && index < SECOND_FRAME_FROM_THE_LAST
      strike_bonus_score(frames, index)
    elsif frame.strike? && index == SECOND_FRAME_FROM_THE_LAST
      frames[index + 1].first_score + frames[index + 1].second_score
    elsif frame.spare? && index < LAST_FRAME
      frames[index + 1].first_score
    else
      Shot::ZERO_SCORE
    end
  end

  def strike_bonus_score(frames, index)
    if frames[index + 1].strike?
      frames[index + 1].first_score + frames[index + 2].first_score
    else
      frames[index + 1].score
    end
  end
end
