class ApplicationController < ActionController::Base
  include SessionHelper

  def require_login
    unless signed_in?
      flash[:danger] = 'Требуется логин'
      redirect_to session_sendcode_url
    end
  end

  def redirect_to404
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def redirect_to500
    render file: "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
  end
end
