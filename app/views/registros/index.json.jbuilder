json.array!(@registros) do |registro|
  json.extract! registro, :descripcion
  json.url registro_url(registro, format: :json)
end
