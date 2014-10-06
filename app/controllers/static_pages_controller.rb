class StaticPagesController < ApplicationController
  skip_authorization_check

  def home
    @fullscreen = true
  end
end