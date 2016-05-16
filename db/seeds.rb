Usuario.create!([
  {email: "admin@gmail.com", encrypted_password: "$2a$10$YOgQ.GyrqazdzaXhe6bfx.CD.mpjQwVewJtE1htUaZGu7RWZ5pyEy", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: "2016-05-16 18:31:19", last_sign_in_at: "2016-05-16 18:31:19", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", nombre: nil}
])

Dependencia.create!([
  {nombre: "UNIDAD GESTION ADMINISTRATIVA"},
  {nombre: "UNIDAD GESTION EJECUTIVA"}
])
Departamento.create!([
  {nombre: "CORDINACION DE SISTEMAS", dependencia_id: 2}
])
Tipo.create!([
  {nombre: "ALTO CARGO"},
  {nombre: "ADMINISTRATIVOS"},
  {nombre: "OBREROS"}
])
