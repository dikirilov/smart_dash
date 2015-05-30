# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'rubygems'
require 'json'
require 'nokogiri'
SCHEDULER.every '10s' do
#  data_temp = Net::HTTP.get(URI.parse("http://api.openweathermap.org/data/2.5/weather?q=Moscow,ru&units=metric")).chomp
#  data_cur = Net::HTTP.get(URI.parse("http://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"))
#  cur = JSON.parse(data_cur)

#  tomorrow = (Time.now+86400).strftime("%Y-%m-%d")
  temp = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml"))).css("forecast fact temperature").text
  forecast = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml")))
  temp_min = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_from").text
  temp_max = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_to").text

#p temp_min
#p temp_max

#.at_xpath('//forecast/day[@date="'+tomorrow+'"]/day_part[@type="day"]/temperature_from').content
  currency = Nokogiri::XML(Net::HTTP.get(URI.parse("http://www.cbr.ru/scripts/XML_daily.asp"))).at_xpath('//ValCurs')
  usd = currency.at_xpath('//Valute[@ID="R01235"]/Value').content 
  eur = currency.at_xpath('//Valute[@ID="R01239"]/Value').content

  traffic = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/bar/reginfo.xml?ncrnd=9742")))
  traff = traffic.at_xpath('//traffic')
  tr_num = traff.at_xpath('//level').content
  tr_lev = traff.at_xpath('//hint').content

#  if (data_temp == "failed to connect ")
#    temp = "No connection :("
#  else 
#    temp = JSON.parse(data_temp)["main"]["temp"].round
#  end
  send_event('forecast', { text: ((temp_min.to_i+temp_max.to_i)/2).round.to_s+"\n"+temp.to_s })
  send_event('usd_cur', { text: usd.to_s })
  send_event('traffic', { text: tr_num, level: tr_lev })
end
