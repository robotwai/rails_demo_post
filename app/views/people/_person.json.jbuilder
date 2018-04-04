json.extract! person, :id, :name, :address, :phone, :created_at, :updated_at
json.url person_url(person, format: :json)
