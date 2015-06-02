# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'rubygems'
require 'json'
require 'nokogiri'
SCHEDULER.every '10s' do

  temp = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml"))).css("forecast fact temperature").text
  forecast = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml")))
  temp_min = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_from").text
  temp_max = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_to").text

#p temp_min
#p temp_max

#  currency = Nokogiri::XML(Net::HTTP.get(URI.parse("http://www.cbr.ru/scripts/XML_daily.asp"))).at_xpath('//ValCurs')
#  usd = currency.at_xpath('//Valute[@ID="R01235"]/Value').content 
#  eur = currency.at_xpath('//Valute[@ID="R01239"]/Value').content

  traffic = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/bar/reginfo.xml?ncrnd=9742"))).css("traffic level").text
#  traff = traffic.at_xpath('//traffic')
#  tr_num = traff.at_xpath('//level').content
#  tr_lev = traff.at_xpath('//hint').content
  time = Time.now.strftime("%H:%M")

  send_event('forecast', { text: ((temp_min.to_i+temp_max.to_i)/2).round.to_s+"\n"+temp.to_s, from_info: "Yandex", updatedAt: time })
#  send_event('usd_cur', { text: usd.to_s, from_info: "CBR" })
  send_event('traffic', { text: traffic, from_info: "Yandex", updatedAt: time })
end
