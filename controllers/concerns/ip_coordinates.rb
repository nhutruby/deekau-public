module IpCoordinates
  extend ActiveSupport::Concern

  private
  def ip_coordinates(request)
    if request.location.ip == "127.0.0.1"
      return [106.629664, 10.823099]
    else
      return [request.location.longitude, request.location.latitude]
    end
  end

end