json.extract! user, :id, :name, :email, :role, :active, :created_at, :updated_at
json.url user_url(user, format: :json)
