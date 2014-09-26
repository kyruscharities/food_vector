class LocatedFoodSource < ActiveRecord::Base
  belongs_to :food_source
  validates_presence_of :food_source

  validates_presence_of :lat
  validates_numericality_of :lat, greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0

  validates_presence_of :lon
  validates_numericality_of :lon, greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0

  # can be part of an analysis
  belongs_to :analysis

  default_scope {includes(:food_source)}

  def as_json(options={})
    super(options.merge({include: :food_source}))
  end

  def as_array
    [lat, lon]
  end
end
