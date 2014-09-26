class Analysis < ActiveRecord::Base

  after_initialize :init

  validates_presence_of :name

  belongs_to :user
  validates_presence_of :user

  belongs_to :geo_region
  validates_presence_of :geo_region
  accepts_nested_attributes_for :geo_region, allow_destroy: true

  has_many :analyzed_geo_regions, class_name: 'GeoRegion'

  delegate :nw, to: :geo_region
  delegate :se, to: :geo_region

  has_many :located_food_sources

  def located_healthy_food_sources
    located_food_sources.includes(:food_source).where(food_source: {healthy: true})
  end

  def located_unhealthy_food_sources
    located_food_sources.includes(:food_source).where(food_source: {healthy: false})
  end

  def clear_analysis_results!
    analyzed_geo_regions.delete_all
    located_food_sources.delete_all
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

  def analyze!
    clear_analysis_results!

    # identify and store all the regions
    GeoRegionSplitter.split(geo_region, 900).each { |r| analyzed_geo_regions.append r }

    raise 'No suitable geographic regions found to analyze' if analyzed_geo_regions.empty?

    # calculate all the risk scores
    analyzed_geo_regions.each { |r| r.calculate_risk_score }
  end

  def analysis_complete?
    # analysis is complete when all blocks have a risk score
    analyzed_geo_regions.where(risk_score: nil).empty?
  end

  def analysis_progress
    "#{analyzed_geo_regions.where.not(risk_score: nil).count} / #{analyzed_geo_regions.count}"
  end

  def init
    build_geo_region unless geo_region
  end
end
