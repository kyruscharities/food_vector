json.array!(@geographic_data_points) do |geographic_data_point|
  json.extract! geographic_data_point, :id, :geo_region_id, :type,, :data
  json.url geographic_data_point_url(geographic_data_point, format: :json)
end
