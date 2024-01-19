# 引数チェック
module Validator
  YEAR_RANGE = 1970..2100 # 1970年から2100年まで
  MONTH_RANGE = 1..12     # 1月から12月まで

  def validate_argv
    if !@options['y'].nil?
      if @options['m'].nil?
        puts "cal: this feature is not implemented. use -y option with -m option"
        exit
      end
      if !YEAR_RANGE.include?(@options['y'].to_i)
        puts "cal: year `#{@options['y']}' not in range #{YEAR_RANGE}"
        exit
      end
    end

    if !@options['m'].nil?
      if !MONTH_RANGE.include?(@options['m'].to_i)
        puts "cal: #{@options['m']} is neither a month number (#{MONTH_RANGE}) nor a name"
        exit
      end
    end
  end
end
