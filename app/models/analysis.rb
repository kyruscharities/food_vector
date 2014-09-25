class Analysis < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  has_many :healthy_food_sources, class: FoodSource

  has_many :unhealthy_food_sources, class: FoodSource

  has_one :geo_region
  validates_presence_of :geo_region
  accepts_nested_attributes_for :geo_region

  validates_presence_of :resolution_mi
  validates_numericality_of :resolution_mi, greater_than: 0

  has_many :analyzed_geo_blocks

  has_many :located_food_sources

  scope :located_healthy_food_sources, -> { where('located_food_sources.healthy = ?', true) }
  scope :located_unhealthy_food_sources, -> { where('located_food_sources.healthy = ?', false) }
end
