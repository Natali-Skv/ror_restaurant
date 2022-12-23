class ApplicationController < ActionController::Base
  include SessionHelper
  around_action :switch_locale

  def require_login
    redirect_to session_sendcode_url unless signed_in?
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def switch_locale(&action)
    parsed_locale = params[:locale]
    p 'TODOTODO'
    p parsed_locale
    p I18n.available_locales
    # locale = I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : I18n.default_locale
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def redirect_to404
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def redirect_to500
    render file: "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
  end
end
