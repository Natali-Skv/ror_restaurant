class ApplicationController < ActionController::Base
  include SessionHelper

  def require_login
    redirect_to session_sendcode_url unless signed_in?
  end

  def redirect_to404
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def redirect_to500
    render file: "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
  end
end
