# Beeline IoT M2M
[![Gem Version](https://badge.fury.io/rb/beeline_iot.svg)](https://badge.fury.io/rb/beeline_iot)

Библиотека для взаимодействия с Центром Управления IoT M2M Билайн Бизнес.  
[Официальный сайт](https://iot.beeline.ru/)  
[Официальная документация](https://iot.beeline.ru/#/m2m/api_guide)

## Установка

Добавьте в ваш Gemfile:

`gem "novofon"`

И выполните команду:

`bundle install`

Или установите с помощью команды:

`gem install novofon`

## Использование

C помощью модуля:

```ruby
# Авторизация.
auth_data = {
  username: "e1xx",
  password: "qweqwe",
  client_id: "3",
  client_secret: "7LWdlTpx9PYrqUz0sy28mlFH1pt38fPgqOkfkzBc",
  grant_type: "password"
}
BeelineIot::Client.login(auth_data)

# Также возможно задать авторизационные данные так.
BeelineIot.grant_type = "password"
BeelineIot.log_requests = false # по-умолчанию

# Получение списка сим-карт.
dashboard_id = 12345
response = BeelineIot::Client.request(
  :post, 
  "/api/v0/dashboards/#{dashboard_id}/sim_cards/list_all_sim"
)

# Получение списка сим-карт доступным методом.
dashboard_id = 12345
response = BeelineIot::Client.sim_list(dashboard_id)
```

С помощью экземпляра класса:

```ruby
# Авторизация.
auth_data = {
  username: "e1xx",
  password: "qweqwe",
  client_id: "3",
  client_secret: "7LWdlTpx9PYrqUz0sy28mlFH1pt38fPgqOkfkzBc",
  grant_type: "password"
}
client = BeelineIot::Client.new(auth_data)
client.login(auth_data)

# Получение информации по SIM-карте, дополнительные параметры тоже можно передавать.
dashboard_id = 12345
params = { per_page: 5 }
response = BeelineIot::Client.request(
  :get,
  "/api/v0/dashboards/#{dashboard_id}/sim_cards/#{sim_id}",
  params
)

# Получение информации по SIM-карте доступным методом, дополнительные параметры тоже можно передавать.
dashboard_id = 12345
sim_id = 987654
params = { order: { id: "asc" } }
response = BeelineIot::Client.get_sims(dashboard_id, sim_id, params)
```

## Доступные методы

Вы можете использовать доступные методы или метод `.request()` в таком формате:

```ruby
BeelineIot::Client.request(:method, "path", params = {})
client.request(:method, "path", params = {})
```

* `sim_list(dashboard_id, params = {})` - список SIM-карт
* `get_sims(dashboard_id, sim_id, params = {})` - получение информации по SIM-карте
* `rate_plans(dashboard_id, params = {})` - список тарифных планов
* `communication_plans(dashboard_id, params = {})` - список услуг
