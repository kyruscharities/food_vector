class StaticPagesController < ApplicationController
  def home
    redirect_to analyses_path if user_signed_in?
  end
end