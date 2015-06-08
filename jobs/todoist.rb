#!/bin/env ruby
#encoding: utf-8

require "rubygems"
require "json"

#todoist_token = 'YOUR_TODOIST_TOKEN_HERE'

SCHEDULER.every '3s' do
    uri = URI.parse("https://todoist.com/API/query?queries=[%22today%22]&token=1f1af0cef3170606a9d059d0a6fd2800b592c91f")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
     
    if response.code == "200"
      result = JSON.parse(response.body)
#      p result
      list = "<ul>"
      i = 0
      while (i < 5 && result[0]["data"][i])
        item = result[0]["data"][i]
        i += 1
        list += "<li>" + item["content"] + "</li>" 
      end
      list += "</ul>"
      send_event('todoist', { body: list, title: "Задачи", updatedAt: Time.now.strftime("%H:%M"), from_info: "Todoist" })
    end
end
