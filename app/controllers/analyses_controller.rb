class AnalysesController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  after_filter :do_analysis, only: [:create]

  def new
    @analysis = Analysis.new
    @analysis.geo_region = GeoRegion.new
    new!
  end

  def analyze
    do_analysis
    redirect_to analysis_path(resource)
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :resolution_mi, :analysis_result_id,
                                     :analyzed_at, geo_region_attributes: [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end

  def do_analysis
    # don't do analysis if there are errors
    return unless resource.errors.empty?

    resource.clear_analysis_results!
    AnalysisWorker.perform_async(resource.id)
    flash[:notice] = "The analysis has started analyzing"
  end
end
