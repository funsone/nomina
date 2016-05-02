json.array!(@registros) do |registro|
  json.extract! registro, :id, :descripcion, :usuario_id, :tipo_de_accion
  json.url registro_url(registro, format: :json)
end
