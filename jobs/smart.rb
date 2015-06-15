#!/bin/env ruby
#encoding: utf-8

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
require 'rubygems'
require 'json'
require 'nokogiri'
SCHEDULER.every '10s' do

  temp = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml"))).css("forecast fact temperature").text
  forecast = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/weather-ng/forecasts/27612.xml")))
  temp_min = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_from").text
  temp_max = forecast.css("forecast day")[1].css("day_part")[1].css("temperature_to").text

p temp

  traff_lev = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/bar/reginfo.xml?ncrnd=9742"))).at_xpath('//info/traffic/level').content  
  traff_hint = Nokogiri::XML(Net::HTTP.get(URI.parse("http://export.yandex.ru/bar/reginfo.xml?ncrnd=9742"))).at_xpath('//info/traffic/hint').content 

p traff_lev

  time = Time.now.strftime("%H:%M")

  send_event('forecast', { text: (((temp_min.to_i+temp_max.to_i)/2).round.to_s+"°"), utext: (temp.to_s+"°"), from_info: "Yandex", updatedAt: time, title: "Погода", pre_text: "Сейчас", pre_utext: "Завтра" })
  send_event('traffic', { text: traff_lev, utext: traff_hint, from_info: "Yandex", updatedAt: time, title: "Пробки" })
end
