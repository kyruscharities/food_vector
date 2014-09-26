class Analysis < ActiveRecord::Base

  after_initialize :init

  validates_presence_of :name

  belongs_to :user
  validates_presence_of :user

  belongs_to :geo_region
  validates_presence_of :geo_region
  accepts_nested_attributes_for :geo_region, allow_destroy: true

  has_many :analysis_geo_region_scores
  has_many :geo_regions, through: :analysis_geo_region_scores

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
    analysis_geo_region_scores.delete_all
    located_food_sources.delete_all
  end

  def analyze!
    AnalysisWorker::AnalysisGenerateRiskScores.perform_async(self.id)
  end

  def locate_food_sources!
    AnalysisWorker::LocateFoodSourcesForGeoRegion.perform_async(self.id)
  end

  def analysis_complete?
    # analysis is complete when all blocks have a risk score
    analysis_geo_region_scores.where(risk_score: nil).empty?
  end

  def analysis_progress
    "#{analysis_geo_region_scores.where.not(risk_score: nil).count} / #{analysis_geo_region_scores.count}"
  end

  def init
    build_geo_region unless geo_region
  end
end
