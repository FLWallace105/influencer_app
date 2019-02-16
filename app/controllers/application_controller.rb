class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from ArgumentError, with: :handle_internal_server

  def handle_internal_server
    render "errors/500", status: :internal_error
  end


end
