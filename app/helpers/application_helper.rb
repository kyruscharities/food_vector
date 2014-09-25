module ApplicationHelper
  def lat_lon(lat, lon)
    "Lat <code>#{lat}</code>, Lon <code>#{lon}</code>".html_safe
  end
end
