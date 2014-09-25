json.array!(@food_sources) do |food_source|
  json.extract! food_source, :id, :business_name
  json.url food_source_url(food_source, format: :json)
end
