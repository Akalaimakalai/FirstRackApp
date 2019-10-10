class App

  require_relative 'time_formater'

  def call(env)
    worker = TimeFormater.new(env)

    if worker.valid?
      worker.working
    else
      worker.on_strike
    end
  end
end
