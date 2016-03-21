json.array!(@tipos) do |tipo|
  json.extract! tipo, :id, :nombre
  json.url tipo_url(tipo, format: :json)
end
