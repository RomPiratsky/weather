Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'weather', to: 'weathers#search_city_key'
  get 'weather/current', to: 'weathers#current'
  get 'weather/historical', to: 'weathers#historical'
  get 'weather/historical/max', to: 'weathers#max_temp_last_24'
  get 'weather/historical/min', to: 'weathers#min_temp_last_24'
  get 'weather/historical/avg', to: 'weathers#avg_temp_last_24'
  get 'weather/by_time', to: 'weathers#by_time'
  get 'weather/health', to: 'weathers#health'


end
