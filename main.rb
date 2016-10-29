require 'json'
require 'rest-client'

# status
user = 'daikin'
password = 'pichonkun'
url = "https://#{user}:#{password}@api-10.daikin.ishikari-dc.net"
response = RestClient.get url

# get
machine_id = 4
url = "https://#{user}:#{password}@api-10.daikin.ishikari-dc.net/equipments/#{machine_id}/"
response = RestClient.get url
puts response.body

# post
machine_id = 4
params = {"id": machine_id,
  "status": {
    "power": 1,
    "operation_mode": 1,
    "set_temperature": 25,
    "fan_speed": 0,
    "fan_direction": 0
  }
}
url = "https://#{user}:#{password}@api-10.daikin.ishikari-dc.net/equipments/#{machine_id}/"
print url
response = RestClient.post url, params.to_json, {content_type: :json, accept: :json}
puts response.body
