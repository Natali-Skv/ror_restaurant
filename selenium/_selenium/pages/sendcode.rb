# frozen_string_literal: true

require './pages/page'

class SendcodePage < Page
  def initialize(base_url, driver)
    super
    @path = '/session/sendcode'
  end

  def open
    super
    @phone_input = @driver.find_element :id, 'phone-input'
    self
  end

  def submit_form
    submit = @driver.find_element name: :commit
    submit.click
    self
  end

  def fill_form_with(phone)
    @phone_input.send_keys phone
    self
  end

  # def submit_form
  #   submit = form.find_element name: :commit
  #   submit.click
  #   self
  # end

  # def result
  #   driver.find_element(id: :results).text
  # end

  # def input_value
  #   form.find_element(name: :to_value).attribute('value')
  # end

  # def result_header_value
  #   form.find_element(xpath: '//*[@id="results"]/h2').text
  # end

  # def considered_header_value
  #   form.find_element(xpath: '//*[@id="results"]/h3').text
  # end

  # def result_inner_html
  #   driver.find_element(id: :results).attribute('innerHTML')
  # end

  # def simon_factorials_result(num)
  #   driver.find_element(xpath: "//*[@id='results']/p[#{num}]").text
  # end

  # def considered_factorials(num)
  #   driver.find_element(xpath: "//*[@id='results']/table/tbody/tr[#{num}]/td[1]").text
  # end

  # def considered_factorials_iters(num)
  #   driver.find_element(xpath: "//*[@id='results']/table/tbody/tr[#{num}]/td[2]").text
  # end
  attr_reader :path, :phone_input


  protected

end
