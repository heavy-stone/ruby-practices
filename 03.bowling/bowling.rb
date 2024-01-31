#!/usr/bin/env ruby
# frozen_string_literal: true

FRAME_10 = 9
FRAME_9 = 8

score_args = ARGV[0]
scores = score_args.split(',')
shots = []
scores.each do |score|
  if score == 'X'
    shots << 10
    shots << 0
  else
    shots << score.to_i
  end
end

frames = []
shots.each_slice(2).with_index(0) do |shot, i|
  if i < FRAME_10
    frames << shot
  elsif i == FRAME_10
    shot -= [0] if shot[0] == 10
    frames << shot
  elsif i > FRAME_10
    shot -= [0] if shot[0] == 10
    frames.last.push(*shot)
  end
end

point_frames = []
frames.each_with_index do |frame, i|
  if frame[0] == 10 && i < FRAME_9
    if frames[(i + 1)][0] == 10
      frame.push(10)
      frame.push(frames[i + 2][0])
    else
      frame.push(*frames[i + 1])
    end
  elsif frame[0] == 10 && i == FRAME_9
    frame.push(frames[i + 1][0])
    frame.push(frames[i + 1][1])
  elsif frame.sum == 10 && i < FRAME_10
    frame.push(frames[(i + 1)][0])
  end
  point_frames.push(frame)
end

puts point_frames.flatten.sum
