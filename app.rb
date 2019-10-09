class App

  PATHS = {
    "GET /time" => "time"
  }

  FORMATS = [ "year", "month", "day", "hour", "min", "sec" ]

  def call(env)
    @status = 404
    @headers = { 'Content-Type' => 'text/plain' }
    @body = ["Page not found!\n"]

    work = find_path(env)

    if work
      set_params(env)
      send(work)
    end

    [@status, @headers, @body]
  end

  private

  def find_path(env)
    App::PATHS["#{env["REQUEST_METHOD"]} #{env["REQUEST_PATH"]}"]
  end

  def time
    extras = @params.select { |i| !App::FORMATS.include?(i) }
    return error(extras) unless extras.empty?
    methods = App::FORMATS.select { |i| @params.include?(i) }

    @status = 200
    start = Time.now
    date = []
    time = []
    methods.each do |i|
      if ["year", "month", "day"].include?(i)
        date << start.send(i)
        date << "-"
      elsif ["hour", "min", "sec"].include?(i)
        time << start.send(i)
        time << ":"
      end
    end

    date_string = ""
    date.reverse!.drop(1).reverse!.each do |i|
      date_string += i.to_s
    end

    time_string = ""
    time.reverse!.drop(1).reverse!
    .each do |i|
      time_string += i.to_s
    end

    @body = ["#{date_string} #{time_string}\n"]
  end

  def set_params(env)
    step1 = env["QUERY_STRING"]
    step2 = step1.split('&').select { |i| i.include?('format') }
    @params = step2.first.split('=').last.split('%')
  end

  def error(extras)
    @status = 400
    @body = ["Unknown time format #{extras}\n"]
  end

end
