# Примеры тестов на Selenium

В данной директории есть стри примера работы с Selenium:

`selenium-ide.side` - пример работы с Selenium IDE, который можно открыть в браузере (чтобы это можно было сделать, необходимо сначала установить расширение Selenium в браузер). Это программа минимум, которую нужно выполнить для зачета по пункту "тесты Selenium".

**Примечание** Этот пример может не запускаться в Firefox. Попробуйте Chrome!

`selenium_webdriver.rb` - пример работы с Selenium Webdriver из Ruby-кода. Запустить можно с помощью команды `./selenium.rb` или `ruby selenium.rb`. Этот код следует воспринимать как пример работы с Selenium - настоящие тесты так не пишутся, т.к. в коде содержится очень много промежуточных и специфичных для конкретной страницы операций (например, поиск по id конкретного элемента и т.п.). Минусов тут как минимум два: во-первых, это усложняет чтение кода - большое количество специфичных операций скрывает логику работы, а во-вторых, если на странице меняется верстка, менять под нее код, написанный "простыней", тоже не очень приятно и удобно. 

`selenium_webdriver_pages.rb` - пример работы с Selenium Webdriver из Ruby-кода с учетом лучших практик написания таких тетов, наиболее важной из них является использования [паттерна Page Object](https://martinfowler.com/bliki/PageObject.html). Запустить можно с помощью команды `./selenium_webdriver_pages.rb` или `ruby selenium_webdriver_pages.rb`.

Основное отличие от предыдущего примера состоит в том, что здесь введена абстракция - т.н. [PageObjects](https://martinfowler.com/bliki/PageObject.html). Они позволяют скрыть логику доступа к конкретным элементам страницы за набором методов, и писать тесты на более высоком уровне абстракции. Так, вместо

```ruby
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :chrome

# какая-то логика открытия страницы.

login_form = driver.find_element id: 'login-form'

login_input = login_form.find_element name: 'login'
login_input.send_keys 'login'

password_input = login_form.find_element name: 'password'
password_input.send_keys 'password'

submit = login_form.find_element name: 'submit'
submit.click
```

можно писать

```ruby
require 'selenium-webdriver'
# require 'login_page' откуда-то.

driver = Selenium::WebDriver.for :chrome

# Часто экземпляр driver используется несколькими страницами, в данном случае driver - это нечто сродни вкладке браузера.
login_page = LoginPage.new driver

login_page
  .fill_credentials(login: 'login', password: 'password')
  .submit_form
```

что во-первых, короче, а во-вторых, сразу позволяет понять, что делается в конкретной строчке конкретного теста.

Однако для того, чтобы так написать, нужно самому организовать иерархию PageObject'ов. Пример в директории `./pages`.
