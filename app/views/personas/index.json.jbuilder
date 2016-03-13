json.array!(@personas) do |persona|
  json.extract! persona, :id, :tipo_cedula, :cedula, :nombres, :apellidos, :lista_id, :telefono_fijo, :telefono_movil, :fecha_de_nacimiento, :correo, :direccion, :sexo, :estado_civil, :grado, :status
  json.url persona_url(persona, format: :json)
end
