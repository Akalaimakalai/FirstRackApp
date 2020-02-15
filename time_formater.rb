class TimeFormater

  PATHS = {
    "GET /time" => "do_format"
  }

  FORMATS =  {
    "year" => "%Y-",
    "month" => "%m-",
    "day" => "%d ",
    "hour" => "%H:",
    "minute" => "%M:",
    "secend" => "%S"
  } 

  attr_reader :extras

  def initialize(env)
    @env = Rack::Request.new(env)
  end

  def valid?
    TimeFormater::PATHS.include?("#{@env.request_method} #{@env.path}")
  end

  def form_params
    @params = @env.params["format"].split(',')
  end

  def find_extras
    form_params
    @extras = @params.select { |i| !TimeFormater::FORMATS.include?(i) }
  end

  def do_format
    str = ""
    TimeFormater::FORMATS.select { |i| @params.include?(i) }.each_value { |i| str += i }
    Time.now.strftime(str)
  end
end
