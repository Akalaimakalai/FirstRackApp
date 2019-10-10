class Pathfinder

  PATHS = {
    "GET /time" => "do_format"
  }

  def do_u_know_de_way?(request)
    Pathfinder::PATHS.include?("#{request.request_method} #{request.path}")
  end

  def we_must_find_de_way(request)
    Pathfinder::PATHS["#{request.request_method} #{request.path}"]
  end
end
