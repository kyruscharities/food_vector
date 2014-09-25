class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    # log the error
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"

    # render access denied
    @message = exception.message
    respond_to do |format|
      format.html { render 'shared/access_denied' }
      format.json { render :json => {:error => @message} }
    end
  end

  def after_sign_in_path_for(resource)
    path = session[:user_return_to].to_s

    # session[:user_return_to] is set somehow when a session expires
    if session[:user_return_to].nil?
      path = analyses_path
    end

    path
  end

  def after_sign_out_path_for(resource)
    root_path
  end
end
