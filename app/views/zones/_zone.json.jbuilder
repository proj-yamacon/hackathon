json.extract! zone, :id, :zone_name, :target_temperature, :current_temperature, :created_at, :updated_at, :machine_id
json.people  @people
json.url zone_url(zone, format: :json)
