require 'mqtt'
 
# Set your MQTT server
MQTT_SERVER = 'mqtt://localhost'
 
# Set the MQTT topics you're interested in and the tag (data-id) to send for dashing events
MQTT_TOPICS = { 'smart/dash' => 'mqtt_widget',
              }
 
# Start a new thread for the MQTT client
Thread.new {
  MQTT::Client.connect(:host => 'localhost', :port => 1883) do |client|
    client.subscribe('smart/#')
 
    # Sets the default values to 0 - used when updating 'last_values'
#    current_values = Hash.new(0)
 
    client.get do |topic,message|
p topic
p message
#      tag = MQTT_TOPICS[topic]
 #     last_value = current_values[tag]
  #    current_values[tag] = message
      time = Time.now.strftime("%H:%M")
      send_event('mqtt', { text: message, updatedAt: time, from_info: "MQTT" })
    end
  end
}

