class FoodSourcesController < ApplicationController
  inherit_resources

  private
  def food_source_params
    params.require(:food_source).permit(:business_name, :healthy)
  end
end
