json.array!(@requisitos) do |requisito|
  json.extract! requisito, :id, :nombre
  json.url requisito_url(requisito, format: :json)
end
