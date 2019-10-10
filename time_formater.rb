class TimeFormater

  require_relative 'pathfinder'

  FORMATS =  {
    "year" => "%Y-",
    "month" => "%m-",
    "day" => "%d ",
    "hour" => "%H:",
    "minute" => "%M:",
    "secend" => "%S"
  } 

  def initialize(env)
    @env = Rack::Request.new(env)
    @knuckles = Pathfinder.new
  end

  def valid?
    @knuckles.do_u_know_de_way?(@env)
  end

  def working   
    send(@knuckles.we_must_find_de_way(@env), @env)
  end

  def do_format(env)
    @params = env.params["format"].split(',')
    extras = @params.select { |i| !TimeFormater::FORMATS.include?(i) }
    return error_unknown_params(extras) unless extras.empty?
    time_params = TimeFormater::FORMATS.select { |i| @params.include?(i) }
    str = ""
    time_params.each_value { |i| str += i }
    [ 200, { 'Content-Type' => 'text/plain' }, ["#{Time.now.strftime(str)}\n"] ]
  end

  def error_unknown_params(extras)
    [ 400, { 'Content-Type' => 'text/plain' }, [ "Unknown time format #{extras}\n" ] ]
  end

  def on_strike
    [ 404, { 'Content-Type' => 'text/plain' }, ["Page not found!\n"] ]
  end
end
