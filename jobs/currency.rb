
require 'rubygems'
require 'nokogiri'

SCHEDULER.every '1d' do

  currency = Nokogiri::XML(Net::HTTP.get(URI.parse("http://www.cbr.ru/scripts/XML_daily.asp"))).at_xpath('//ValCurs')
  usd = currency.at_xpath('//Valute[@ID="R01235"]/Value').content
  eur = currency.at_xpath('//Valute[@ID="R01239"]/Value').content

  today = Time.now.strftime("%d.%m.%Y")
  send_event('usd_cur', { text: usd.to_s, from_info: "CBR", updatedAt: today })
end 



