json.array!(@cargos) do |cargo|
  json.extract! cargo, :id, :nombre, :departamento_id
  json.url cargo_url(cargo, format: :json)
end
