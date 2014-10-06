class Analysis < ActiveRecord::Base

  after_initialize :init
  after_update :clear_analysis_after_region_change

  validates_presence_of :name

  belongs_to :user
  validates_presence_of :user

  belongs_to :geo_region
  validates_presence_of :geo_region
  accepts_nested_attributes_for :geo_region, allow_destroy: true

  validate :geo_region_is_small_enough

  has_many :analysis_geo_region_scores
  has_many :geo_regions, through: :analysis_geo_region_scores

  delegate :nw, to: :geo_region
  delegate :se, to: :geo_region

  def food_sources_near_the_region
    nw_lat = geo_region.nw_lat + 0.1
    nw_lon = geo_region.nw_lon - 0.1
    se_lat = geo_region.se_lat - 0.1
    se_lon = geo_region.se_lon + 0.1

    LocatedFoodSource.where('lat < :nw_lat AND lat > :se_lat AND lon > :nw_lon AND lon < :se_lon', {nw_lat: nw_lat, nw_lon: nw_lon, se_lat: se_lat, se_lon: se_lon})
  end

  def clear_analysis_results!
    analysis_geo_region_scores.delete_all
  end

  def analyze!
    AnalysisWorker::AnalysisGenerateRiskScores.perform_async(self.id)
  end

  def locate_food_sources!
    AnalysisWorker::LocateFoodSourcesForGeoRegion.perform_async(self.id)
  end

  def complete_analysis_subregions
    analysis_geo_region_scores.where.not(risk_score: nil)
  end

  def incomplete_analysis_subregions
    analysis_geo_region_scores.where(risk_score: nil)
  end

  def total_analysis_subregions
    analysis_geo_region_scores.count
  end

  def analysis_complete?
    total_analysis_subregions > 0 and incomplete_analysis_subregions.count == 0
  end

  def init
    build_geo_region unless geo_region
  end

  def clear_analysis_after_region_change
    unless name_changed? or description_changed?
      clear_analysis_results!
      locate_food_sources!
    end
  end

  def as_json(options={})
    super(options.merge({include: :geo_region}))
  end

  def geo_region_is_small_enough
    errors.add(:name, 'select a smaller region, the current selection will create too many data points to display effectively') unless geo_region && geo_region.valid? && geo_region.number_of_points <= 10000
  end
end
