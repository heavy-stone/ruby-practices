# frozen_string_literal: true

# カレンダーの作成と表示

module Calender
  FIRST_DAY_OF_MONTH = 1
  LAST_DAY_OF_MONTH = -1
  DAY_DIGIT = 2       # 日付の表示桁数
  CALENDER_WIDTH = 20 # カレンダーの表示幅

  def create
    year = @options['y'].nil? ? Date.today.year : @options['y'].to_i
    month = @options['m'].nil? ? Date.today.month : @options['m'].to_i

    first_date = Date.new(year, month, FIRST_DAY_OF_MONTH)
    last_date = Date.new(year, month, LAST_DAY_OF_MONTH)
    month_dates = (first_date..last_date)
    calender_days = month_dates.map do |date|
      formatted_day_string = date.day.to_s
      formatted_day_string = "\e[7m#{formatted_day_string}\e[0m" if date == Date.today # 色反転
      formatted_day_string = formatted_day_string.rjust(DAY_DIGIT)                     # 日付の桁数を揃える
      formatted_day_string += date.saturday? ? "\n" : ' '
      formatted_day_string
    end.join

    first_date.strftime('%B %Y').center(CALENDER_WIDTH) <<
      "\nSu Mo Tu We Th Fr Sa\n" <<
      '   ' * first_date.wday + calender_days
  end

  def show(calender_string)
    puts calender_string
  end
end
