#!/bin/env ruby
#encoding: utf-8

require "net/http"
require "json"

#todoist_token = 'YOUR_TODOIST_TOKEN_HERE'

SCHEDULER.every '3s' do
    uri = URI.parse("https://todoist.com/API/query?queries=[%22today%22]&token=1f1af0cef3170606a9d059d0a6fd2800b592c91f")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
     
    if response.code == "200"
      result = JSON.parse(response.body)
      p result
      send_event('todoist', { text: result[0]["data"][0]["content"], title: "Задачи" })
    end
end
