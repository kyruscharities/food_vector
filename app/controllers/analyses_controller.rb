class AnalysesController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  after_filter :do_locate_food_sources, only: [:create]

  def analyze
    # don't do analysis if there are errors
    return unless resource.errors.empty?
    resource.analyze!
    flash[:notice] = 'Analysis is underway. Please refresh the page occasionally until analysis is complete.'

    redirect_to analysis_path(resource)
  end

  def locate_food_sources
    do_locate_food_sources
    redirect_to analysis_path(resource)
  end

  def analysis_geo_region_scores
    @analysis_geo_region_scores = resource.analysis_geo_region_scores.where.not(risk_score: nil).paginate(page: params[:page], per_page: 1000)
    render json: @analysis_geo_region_scores.to_json
  end

  private
  def analysis_params
    params.require(:analysis).permit(:name, :description, :user_id, :geo_region_id, :analysis_result_id,
                                     :analyzed_at, geo_region_attributes: [:nw_lat, :nw_lon, :se_lat, :se_lon])
  end

  def do_locate_food_sources
    resource.locate_food_sources!
    flash[:notice] = 'Food sources near the analysis region are being located'
  end
end
