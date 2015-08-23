module ApplicationHelper

  def route_has_pattern(request_path, pattern)
    (request_path =~ /#{pattern}/i) != nil
  end

end

 