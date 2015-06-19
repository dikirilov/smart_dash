#!/bin/env ruby
#encoding: utf-8

require 'mqtt'
 
Thread.new {
  MQTT::Client.connect(:host => 'localhost', :port => 1883) do |client|
    client.subscribe('/server/command/nobodyHome')
    client.get do |topic,message|
      time = Time.now.strftime("%H:%M")
      if (message == "ON") then
	mes = "Включен"
      else
	mes = "Выключен"
      end
      send_event('mode', { text: mes, title: "Режим", updatedAt: time, from_info: "openHAB", pre_text: "\"Никого нет дома\"", utext: "" })
    end
  end
}

