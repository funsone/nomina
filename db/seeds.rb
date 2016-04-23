Usuario.create!([
  {email: "admin@gmail.com",password: "12345678"}
])
Dependencia.create!([
  {nombre: "1"}
])
Departamento.create!([
  {nombre: "sistemas", dependencia_id: 1}
])

Tipo.create!([
  {nombre: "admins"},
  {nombre: "alto rango"},
  {nombre: "obreros"}
])
Conceptopersonal.create!([
  {nombre: "BONO", tipo_de_concepto: 0},
  {nombre: "ERROR", tipo_de_concepto: 1}
])
Concepto.create!([
  {nombre: "SUELDO", formula: "@SUELDO/2", modalidad_de_pago: 2, tipo_de_concepto: 0},
  {nombre: "SUELDO4", formula: "@SUELDO/4", modalidad_de_pago: 2, tipo_de_concepto: 0}
])
Concepto::HABTM_Tipos.create!([
  {tipo_id: 1, concepto_id: 1},
  {tipo_id: 2, concepto_id: 1},
  {tipo_id: 3, concepto_id: 2}
])
Tipo::HABTM_Conceptos.create!([
  {tipo_id: 1, concepto_id: 1},
  {tipo_id: 2, concepto_id: 1},
  {tipo_id: 3, concepto_id: 2}
])
Cargo.create!([
  {nombre: "algo", departamento_id: 1, tipo_id: 1, disponible: false}
])
Sueldo.create!([
  {monto: "20000.0", activo: true, cargo_id: 1}
])




Persona.create!([
  {cedula: "32111770", tipo_de_cedula: 1, nombres: "Dolorem eiusmod explicabo Commodo velit culpa au", apellidos: "Ducimus delectus non ea maxime dolor similique n", telefono_fijo: "25803202623", telefono_movil: "81521686424", fecha_de_nacimiento: "1985-07-09", correo: "huxym@yahoo.com", direccion: "Aperiam ex laborum. Illum, consequatur? Omnis sequi voluptas voluptas architecto eos, duis.", sexo: 1, status: "activo", cargo_id: 1, cargas_familiares: nil, sueldo_integral: "16.0", avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, cuenta: "23432423432333240026", FAOV: false, IVSS: false, TSS: true}
])
Contrato.create!([
  {fecha_inicio: "2000-04-05", fecha_fin: nil, tipo_de_contrato: 0, sueldo_externo: nil, persona_id: 1}
])
