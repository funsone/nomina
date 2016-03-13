json.array!(@departamentos) do |departamento|
  json.extract! departamento, :id, :nombre, :sede_id
  json.url departamento_url(departamento, format: :json)
end
