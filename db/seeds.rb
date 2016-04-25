Usuario.create!([
  {email: "admin@gmail.com",password: "12345678"}
])
Dependencia.create!([
  {nombre: "1"}
])
Departamento.create!([
  {nombre: "sistemas", dependencia_id: 1}
])
