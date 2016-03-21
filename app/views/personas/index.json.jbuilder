json.array!(@personas) do |persona|
  json.extract! persona, :id, :cedula, :tipo_de_cedula, :nombres, :apellidos, :telefono_fijo, :telefono_movil, :fecha_de_nacimiento, :correo, :direccion, :sexo, :status, :cargo_id, :cargas_familiares
  json.url persona_url(persona, format: :json)
end
