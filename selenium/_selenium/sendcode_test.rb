#!env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'webdrivers'
require './pages/sendcode'

BASE_URL = 'http://localhost:3000'

class TestSendcode < Minitest::Test
  def setup
    @driver = Selenium::WebDriver.for :chrome
    @sendcode_page = SendcodePage.new BASE_URL, driver
    @sendcode_page.open
  end

  def test_base
    @sendcode_page.fill_form_with('+7 (901) 502-0456')
                  .submit_form
    assert !(@driver.find_element :id, 'checkcode-form').nil?
  end

  # def test_empty_phone
  #   @sendcode_page.submit_form
  #   p @driver.current_url
  #   assert @driver.current_url == @sendcode_page.base_url + @sendcode_page.path
  #   assert (@driver.find_element :id, 'checkcode-form').nil
  # end

  def teardown
    driver.quit
  end

  private

  attr_reader :driver, :input_page
end
