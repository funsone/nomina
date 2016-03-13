json.array!(@lista) do |listum|
  json.extract! listum, :id, :nombre, :sede_id
  json.url listum_url(listum, format: :json)
end
