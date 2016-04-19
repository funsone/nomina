json.array!(@conceptospersonales) do |conceptopersonal|
  json.extract! conceptopersonal, :id, :nombre, :tipo_de_concepto
  json.url conceptopersonal_url(conceptopersonal, format: :json)
end
