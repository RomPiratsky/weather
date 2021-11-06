class WeathersController < ApplicationController
  require 'net/http'
  require 'httpclient'
  API_KEY = 'le805L3EAizAl7XftINwJpxdHuPF7trJ'
  
    
    def current  
      city_weather_full
      temperature = {}
      @metrics.each {|elem| temperature = elem['Temperature']}
      @temp = temperature['Metric']
    end

    def historical
      weather_last_24_hours
      count = 0
      @general = []
      temp_array = []
      time_array = []
      value = []
      @metrics24.select {|elem| temp_array << elem['Temperature']}
      @metrics24.select {|elem| time_array << elem['LocalObservationDateTime']}
      temp_array.select {|elem| value << elem['Metric']}
      while count < time_array.length do
        @general << time_array[count]
        @general << value[count]
        count += 1
      end
      @general
    end

    def max_temp_last_24
      weather_last_24_hours
      temperature = {}
      @metrics24.select {|elem| temperature = elem['TemperatureSummary']}
      temp = temperature['Past24HourRange']
      @max24 = temp['Maximum']
    end

    def min_temp_last_24
      weather_last_24_hours
      temperature = {}
      @metrics24.select {|elem| temperature = elem['TemperatureSummary']}
      temp = temperature['Past24HourRange']
      @min24 = temp['Minimum']
    end

    def avg_temp_last_24
      weather_last_24_hours
      temperature = {}
      @metrics24.select {|elem| temperature = elem['Past24HourTemperatureDeparture']}
      @avg24 = temperature['Metric']
    end

    def by_time
      weather_last_24_hours
      epoch_time = []
      current = {}
      count = 0
      @metrics24.select {|elem| epoch_time << elem['EpochTime']}
      p @metrics24
      epoch_time.each do |elem|
        if elem == params['by_time'].to_i
          @metrics24.select {|elem| current = elem["#{count}"]}
          @t = current['Temperature']
          return @t
        else
          count += 1
          next
        end
      end
      render json: {code: 404}
    end

    def health
      render json: {status: "OK"}
    end

    private

    def search_city_key(city = 'Moscow')
      city = city
      uri = URI("http://dataservice.accuweather.com/locations/v1/cities/search?apikey=#{API_KEY}&q=#{city}")
      @answer = Net::HTTP.get(uri)
      cities = JSON.parse(@answer)
      target_city = cities[0]
      @city_key = target_city['Key']
    end

    def city_weather_full
      search_city_key
      uri = URI("http://dataservice.accuweather.com/currentconditions/v1/#{@city_key}?apikey=#{API_KEY}&details=true")
      weather = Net::HTTP.get(uri)
      @metrics = JSON.parse(weather)
    end

    def weather_last_24_hours
      search_city_key
      uri = URI("http://dataservice.accuweather.com/currentconditions/v1/#{@city_key}/historical/24?apikey=#{API_KEY}&details=true")
      weather = Net::HTTP.get(uri)
      @metrics24 = JSON.parse(weather)
    end
end