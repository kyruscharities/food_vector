class GeographicDataPointsController < ApplicationController
  inherit_resources

  private
  def geographic_data_point_params
    params.require(:geographic_data_point).permit(:geo_region_id, :type, :data)
  end
end
