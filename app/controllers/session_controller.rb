class SessionController < ApplicationController
  before_action :require_login,only: [:logout]

  def logout
    sign_out
    redirect_to root_url
  end

  def show_sendcode; end

  def sendcode
    return redirect_to root_url if signed_in?
    # TODO: добавить кнопку повторной отправки кода
    # TODO добавить обработчик повторной отправки кода

    @phone = params[:phone]
    model_error = Session.sendcode(params[:phone])
    case model_error
    when nil, Session::ERRORS[:ALREADY_IN_QUEUE]
      render :show_checkcode
    when Session::ERRORS[:INVALID_PHONE]
      @error = 'Введите корректный номер'
      render :show_sendcode
    else Session::ERRORS[:INNTERNAL_ERROR]
         redirect_to500
    end
  end

  def show_checkcode; end

  def checkcode
    return redirect_to root_url if signed_in?

    @phone = params[:phone]
    code = params[:code]
    user, model_error = Session.checkcode(@phone, code)
    p '48'
    p user, model_error
    case model_error
    when nil
      sign_in(user)
      redirect_to root_url
    when Session::ERRORS[:WRONG_CODE], Session::ERRORS[:INVALID_CODE]
      @error = 'Неверный код подтверждения'
      render :show_checkcode
    when Session::ERRORS[:INVALID_PHONE]
      @error = 'Введите корректный номер'
      render :show_sendcode
    else Session::ERRORS[:INNTERNAL_ERROR]
         redirect_to500
    end

    # достать код + номер телефона через невидимый инпут
    # провалидировать код
    # сравнить код
    # если ок то найти или создать пользователя в бд
    #     редирект на главную + установить куку
    # иначе отрисовка ошибки
  end
end
