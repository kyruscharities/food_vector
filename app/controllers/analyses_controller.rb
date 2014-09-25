class AnalysesController < ApplicationController
  inherit_resources

  after_filter :analyze_work, only: [:create]

  def new
    @analysis = Analysis.new
    @analysis.geo_region = GeoRegion.new
    new!
  end

  def analyze_work
    resource.clear_analysis_results!

    AnalysisWorker.perform_async(resource.id)

    flash[:notice] = "The analysis has started analyzing"
  end

  def analyze
    analyze_work

    redirect_to analysis_path(resource)
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :resolution_mi, :analysis_result_id,
                                     :analyzed_at, geo_region_attributes: [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end
end
