#!/bin/env ruby
#encoding: utf-8

require 'rubygems'

SCHEDULER.every '3s' do
	temp = Net::HTTP.get(URI.parse("http://192.168.1.74:8080/rest/items/tempHome/state")).to_i
	humi = Net::HTTP.get(URI.parse("http://192.168.1.74:8080/rest/items/humiHome/state")).to_i
	press = Net::HTTP.get(URI.parse("http://192.168.1.74:8080/rest/items/press/state")).to_i

p temp
p humi
p press

	if (press < 100000)
		pr_m = "Циклон"
	elsif (press > 110000)
		pr_m = "Антициклон"
	else
		pr_m = "Нормальное давление"
	end

	umes = ""
	if (temp > 20)
		if (temp < 22)
			if (humi < 80)
				mes = "Комфортные условия"
			else
				mes = "Небольшой дискомфорт"
				umes = "Высокая влажность"
			end
		elsif (temp < 27)
			if (humi < 60)
				mes = "Комфортные условия"
			elsif (humi < 80)
				mes = "Небольшой дискомфорт"
				umes = "Высокая влажность"
			else 
				mes = "Дискомфорт"
				umes = "Очень высокая влажность"
			end
		elsif (temp < 29)
			if (humi < 40)
				mes = "Комфортные условия"
			elsif (humi < 60)
				mes = "Небольшой дискомфорт"
				umes = "Высокая температура"
			elsif (humi < 80)
				mes = "Дискомфорт"
				umes = "Высокая влажность"
			else
				mes = "Сильный дискомфорт"
				umes = "Высокие температура и влажность"
			end
		else
			mes = "Дискомфорт"
			umes = "Очень высокая температура"
		end
	else
		mes = "Дискомфорт"
		umes = "Низкая температура"
	end		
			
	time = Time.now.strftime("%H:%M")
	send_event("comfort", { title: "", text: pr_m, utext: mes, pre_utext: umes, updatedAt: time, from_info: "openHAB" })

end
