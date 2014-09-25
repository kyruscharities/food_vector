json.array!(@analyses) do |analysis|
  json.extract! analysis, :id, :name, :description, :user_id, :geo_region_id, :resolution, :analysis_result_id
  json.url analysis_url(analysis, format: :json)
end
