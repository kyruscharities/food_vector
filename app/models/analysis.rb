class Analysis < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :user
  validates_presence_of :user

  has_one :geo_region
  validates_presence_of :geo_region
  accepts_nested_attributes_for :geo_region

  validates_presence_of :resolution_mi
  validates_numericality_of :resolution_mi, greater_than: 0

  has_many :analyzed_geo_blocks

  has_many :located_food_sources

  def located_healthy_food_sources
    located_food_sources.where('healthy = ?', true)
  end

  def located_unhealthy_food_sources
    located_food_sources.where('healthy = ?', false)
  end

  scope :located_healthy_food_sources, -> { where('located_food_sources.healthy = ?', true) }
  scope :located_unhealthy_food_sources, -> { where('located_food_sources.healthy = ?', false) }

  def clear_analysis_results!
    analyzed_geo_blocks.delete_all
    located_food_sources.delete_all

    update! analyzed_at: nil
  end

  def convertAnalyzedToLatLon()
    analyzed_geo_blocks
=begin
    latLons = []
    analyzed_geo_blocks.each do |block|
      cp = block.geo_region.center_point,
      block.risk_score.to_i.times do
        latLons << cp
      end
    end
    latLons
=end
  end

  def generate_fake_data_points(num_points)
    num_points.to_i.times do
      temp_se_lat = rand(geo_region.se_lat..geo_region.nw_lat)
      temp_se_lon = rand(geo_region.se_lon..geo_region.nw_lon)
      temp_nw_lat = rand(temp_se_lat..geo_region.nw_lat)
      temp_nw_lon = rand(temp_se_lon..geo_region.nw_lon)
      puts "temp_se_lon: #{temp_se_lon}"
      gr = GeoRegion.create! nw_lat: temp_nw_lat,
                             nw_lon: temp_nw_lon,
                             se_lat: temp_se_lat,
                             se_lon: temp_se_lon

      gened_block = AnalyzedGeoBlock.create!(geo_region: gr, risk_score: rand(0..100))
      analyzed_geo_blocks << gened_block
    end
  end
end
