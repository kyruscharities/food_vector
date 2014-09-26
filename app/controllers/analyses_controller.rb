class AnalysesController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  # after_filter :do_analysis, only: [:create]

  def analyze
    do_analysis
    redirect_to analysis_path(resource)
  end

  def locate_food_sources
    resource.locate_food_sources!
    flash[:notice] = 'Started locating food sources'
    redirect_to analysis_path(resource)
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :analysis_result_id,
                                     :analyzed_at, geo_region_attributes: [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end

  def do_analysis
    # don't do analysis if there are errors
    return unless resource.errors.empty?

    resource.clear_analysis_results!
    resource.analyze!
    flash[:notice] = 'Analysis started'
  end
end
