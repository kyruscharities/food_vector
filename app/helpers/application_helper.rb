module ApplicationHelper
  def lat_lon(lat, lon)
    "Lat <code>#{lat}</code>, Lon <code>#{lon}</code>".html_safe
  end

  def geo_region_coords(resource)
    "#{lat_lon *resource.nw} to #{lat_lon *resource.se}".html_safe
  end
end
