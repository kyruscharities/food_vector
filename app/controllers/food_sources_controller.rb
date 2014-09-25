class FoodSourcesController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  private
  def food_source_params
    params.require(:food_source).permit(:business_name, :healthy)
  end
end
