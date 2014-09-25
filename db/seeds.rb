
def load_food_sources(sources, is_healthy)
  (sources || []).each do |name|
    puts "Creating food source #{name}"
    FoodSource.find_or_create_by! business_name: name do |resource|
      resource.healthy = is_healthy
    end
  end
end

sources = YAML.load_file(Rails.root.join('config', 'food_sources.yml'))
load_food_sources sources['healthy'].values.flatten.uniq, true
load_food_sources sources['unhealthy'].try(:uniq), false
