
Usuario.create!(
    email: 'admin@gmail.com', password: '12345678')
    Usuario.all.first.add_role :admin
Usuario.create!(
        email: 'cor@gmail.com', password: '12345678')
        Usuario.all.last.add_role :coordinador
Usuario.create!(
            email: 'reg@gmail.com', password: '12345678')
            Usuario.all.last.add_role :regular
Usuario.current=Usuario.first
$ahora = Time.current
$quincena = ($ahora.day <= 15) ? 0  : 1
Dependencia.create!([
                        { nombre: 'UNIDAD GESTION ADMINISTRATIVA' },
                        { nombre: 'UNIDAD GESTION EJECUTIVA' }
                    ])
Departamento.create!([
                         { nombre: 'CORDINACION DE SISTEMAS', dependencia_id: 1 },
                         { nombre: 'CORDINACION DE limpia', dependencia_id: 2 },
                         { nombre: 'CORDINACION DE RHH', dependencia_id: 1 }
                     ])
Tipo.create!([
                 { nombre: 'ALTO CARGO' },
                 { nombre: 'ADMINISTRATIVOS' },
                 { nombre: 'OBREROS' }
             ])
prng = Random.new
prng.rand(100)
require 'securerandom'
h = Hash['activo' =>1, 'suspendido' =>2,'retirado'=>3]
200.times do |x|
  x=x+1

    Cargo.create!( nombre: 'fds1' + x.to_s, departamento_id: prng.rand(1..3), tipo_id: prng.rand(1..3), disponible: true, sueldos_attributes: [cargo_id:x, monto: 11, activo: true, sueldo_integral: 222])
    Persona.create!(cedula: '241100' + x.to_s, tipo_de_cedula: 1, nombres: SecureRandom.hex[1..6],
    apellidos: SecureRandom.hex[1..6], telefono_fijo: '38886743345', telefono_movil: '', fecha_de_nacimiento: '1991-04-11',
    correo: x.to_s + 'myjuwek@yahoo.com', direccion: 'Quia doloremque ',
    sexo: 1, status: h.key(1), cargo_id: x,
    avatar_file_name: nil, avatar_content_type: nil, avatar_file_size: nil, avatar_updated_at: nil, cuenta: '92604294834535345345',
    FAOV: true, IVSS: false, TSS: false, caja_de_ahorro: false)
    Contrato.create!( fecha_inicio: '2015-06-14', fecha_fin: nil, tipo_de_contrato: 0, sueldo_externo: nil, persona_id: x)
end
