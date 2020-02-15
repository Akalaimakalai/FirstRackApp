class App

  require_relative 'time_formater'

  def call(env)
    @status = 404
    @headers = { 'Content-Type' => 'text/plain' }
    @body = ["Page not found!\n"]
    worker = TimeFormater.new(env)

    if worker.valid?
      if worker.find_extras.empty?
        @status = 200
        @headers = { 'Content-Type' => 'text/plain' }
        @body = ["#{worker.do_format}"]
      else
        @status = 400
        @headers = { 'Content-Type' => 'text/plain' }
        @body = ["#{"Unknown time format #{worker.extras}\n"}"]
      end
    end

    [@status, @headers, @body]
  end
end
