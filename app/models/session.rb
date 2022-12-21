require 'securerandom'
require 'open-uri'
require 'dalli'

MC = Dalli::Client.new('127.0.0.1:11211', {})

class Session < ApplicationRecord
  ERRORS = {
    ALREADY_IN_QUEUE: 'phone already in queue',
    INTERNAL_ERROR: 'internal error',
    INVALID_PHONE: 'invalid phone provided',
    INVALID_CODE: 'invalid code provided',
    WRONG_CODE: 'wrong auth code'
  }

  class << self
    EMAIL = 'nat-s.skv%40yandex.ru'.freeze
    API_KEY = 'PkzvymZDAVs0qasTSsdz1bxhhA'.freeze

    def checkcode(phone, code)
      p phone
      phone_i = phone_to_i(phone)
      p phone_i
      return [nil, ERRORS[:INVALID_PHONE]] unless validate_phone(phone_i)
      return [nil, ERRORS[:INVALID_CODE]] unless validate_code(code)
      return [nil, ERRORS[:WRONG_CODE]] unless code == get_code_from_cach(phone_i)

      user = User.find_by(phone: phone_i)
      user ||= User.create(phone: phone_i)
      return ERRORS[:INTERNAL_ERROR] unless user

      [user, nil]
      # провалидировать код
      # сравнить код
      # если ок то найти или создать пользователя в бд
      #     редирект на главную + установить куку
    end

    def sendcode(phone)
      p phone
      phone_i = phone_to_i(phone)
      p phone_i
      return ERRORS[:INVALID_PHONE] unless validate_phone(phone_i)

      code = (SecureRandom.random_number(9999) + 10_000).to_s[1..]
      p code
      flashcall_err = flashcall(phone_i, code)
      return flashcall_err if flashcall_err

      save_code_err = add_code_to_cach(phone_i, code)
      return save_code_err if save_code_err
      # привести к норм виду
      # сгенерить код
      # сделать запрос на звонок
      # оставить дебажный вывод с кодом
      # добавить код в мемкеш
      # средиректить на страницу подтверждения кода
      # добавить отрисовку номера телефона на странице подтверждения
      # добавить кнопку повторной отправки кода
      # добавить обработчик повторной отправки кода
    end

    def phone_to_i(phone)
      phone_truncated = phone.delete("-+()\s")
      return 0 if phone_truncated.empty?

      phone_truncated[0] = '7'
      phone_truncated.to_i
    end

    def validate_phone(phone)
      phone <= 79_999_999_999 && phone >= 79_000_000_000
    end

    def validate_code(code)
      code.length == 4
    end

    def beauty_phone(phone)
      phone_nums = phone.delete("+-()\s")
      "+7 (#{phone_nums.slice(1, 3)}) #{phone_nums.slice(4, 3)}-#{phone_nums.slice(7, 2)}-#{phone_nums.slice(7, 2)}"
    end

    private

    def flashcall(phone, code)
      # RestClient.get("http://#{EMAIL}:#{API_KEY}@gate.smsaero.ru/v2/flashcall/send?phone=#{phone}&code=#{code}") do |response, _request, _result|
      #   p response
      #   case response.code
      #   when 200
      #     nil
      #   when 400
      #     ERRORS[:ALREADY_IN_QUEUE]
      #   else
      #     ERRORS[:INTERNAL_ERROR]
      #   end
      # end
    end

    def add_code_to_cach(phone, code)
      ERRORS[:INTERNAL_ERROR] unless MC.set(phone, code, 300)
    end

    def get_code_from_cach(phone)
      code = MC.get(phone)
      p code
      code
    end
  end
end