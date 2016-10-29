json.extract! person, :id, :name, :image_name, :gender, :temperature_preference, :comfortable_temperature, :comfortable_humidity, :created_at, :updated_at
json.url person_url(person, format: :json)