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
      day = date.day.to_s
      day = "\e[7m#{day}\e[0m" if date == Date.today # 色反転
      day = day.rjust(DAY_DIGIT)                     # 日付の桁数を揃える
      day += date.saturday? ? "\n" : ' '
      day
    end.join

    @calender_title = first_date.strftime("%B %Y").center(CALENDER_WIDTH)
    @calender_days = '   ' * first_date.wday + calender_days
  end

  def show
    puts @calender_title
    puts "Su Mo Tu We Th Fr Sa"
    puts @calender_days
  end
end
