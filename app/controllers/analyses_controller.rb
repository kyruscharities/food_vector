class AnalysesController < ApplicationController
  inherit_resources

  def new
    @analysis = Analysis.new
    @geo_region = @analysis.build_geo_region
    new!
  end

  def analyze
    # TODO: integrate with someone else's stuff
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :resolution_mi, :analysis_result_id, geo_region:
        [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end
end
