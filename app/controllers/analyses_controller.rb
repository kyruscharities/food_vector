class AnalysesController < ApplicationController
  inherit_resources

  def new
    @analysis = Analysis.new
    @analysis.geo_region = GeoRegion.new
    new!
  end

  def analyze
    # TODO: integrate with someone else's stuff
    resource.analyzed_at = Time.now
    resource.save!
    flash[:notice] = "The analysis has started analyzing"
    redirect_to analysis_path(resource)
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :resolution_mi, :analysis_result_id,
                                     :analyzed_at, geo_region_attributes: [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end
end
