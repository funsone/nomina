json.array!(@people) do |person|
  json.extract! person, :id, :payroll_id, :tipo_cedula, :nombres, :apellidos, :telefono_fijo, :telefono_movil, :fecha_de_nacimiento, :correo, :direccion, :sexo, :estado_civil, :grado, :status
  json.url person_url(person, format: :json)
end
