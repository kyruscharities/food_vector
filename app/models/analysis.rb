class Analysis < ActiveRecord::Base
  validates_presence_of :name

  belongs_to :user
  validates_presence_of :user

  belongs_to :geo_region
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

end
