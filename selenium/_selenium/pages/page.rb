# frozen_string_literal: true

class Page
  attr_reader :base_url, :driver

  def initialize(base_url, driver)
    @base_url = base_url.end_with?('/') ? base_url.chomp : base_url
    @driver = driver
  end

  def open
    driver.navigate.to "#{base_url}#{validated_path}"
    self
  end

  def has_element(timeout)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout) # seconds
    begin
      element = wait.until { driver.find_element(id: '') }
    ensure
      driver.quit
    end
  end

  private

  def validated_path
    raise 'Определите метод path в наследнике класса Page' unless path

    unless path.is_a?(String) || path.start_with?('/')
      raise 'Метод path должен возвращать строку, которая начинается с /'
    end

    path
  end
end
