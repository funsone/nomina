json.array!(Persona.activo) do |persona|
  json.extract! persona, :id, :cedula, :nombres, :apellidos
end
