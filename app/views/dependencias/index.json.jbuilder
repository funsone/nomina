json.array!(@dependencias) do |dependencia|
  json.extract! dependencia, :id, :nombre
  json.url dependencia_url(dependencia, format: :json)
end
