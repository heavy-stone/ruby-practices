#!/usr/bin/env ruby
# frozen_string_literal: true

FRAME_10 = 9
FRAME_9 = 8

# 引数の点数を成形
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end
p shots

# フレーム毎の点数に分割
frames = []
shots.each_slice(2).with_index(0) do |s, i|
  if i < FRAME_10
    frames << s
  elsif i == FRAME_10
    s -= [0] if s[0] == 10 # 第10フレームはstrikeの0点埋めを削除
    frames << s
  elsif i > FRAME_10       # 第10フレームのshot
    s -= [0] if s[0] == 10 # 第10フレームはstrikeの0点埋めを削除
    frames.last.push(*s) # 第10フレームのshotを第10フレームに含める
  end
end
p frames

# 点数計算用の配列作成
point_frames = []
frames.each_with_index do |frame, i|
  puts "第#{i + 1}フレーム: #{frames[i]}"
  if frame[0] == 10 && i < FRAME_9 # 8投目までのstrike
    if frames[(i + 1)][0] == 10    # 次もstrikeの場合
      frame.push(10)               # 1投目の加点
      frame.push(frames[i + 2][0]) # 2投目の加点
    else                           # 次がstrike以外の場合
      frame.push(*frames[i + 1])   # 1,2投目の加点
    end
  elsif frame[0] == 10 && i == FRAME_9 # 9投目のstrike
    frame.push(frames[i + 1][0])       # 1投目の加点
    frame.push(frames[i + 1][1])       # 2投目の加点
  elsif frame.sum == 10 && i < FRAME_10 # ９投目までのspare
    frame.push(frames[(i + 1)][0])      # 1投目の加点
  end
  point_frames.push(frame) # 点数計算用の配列に追加
  puts "合計: #{point_frames.flatten.sum}"
end

# 点数合計の表示
puts point_frames.flatten.sum
