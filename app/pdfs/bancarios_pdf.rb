class BancariosPdf < Prawn::Document
  def initialize(tipo, eco, con, conper)
    super(left_margin: 50, top_margin: 30, right_margin: 20)
    # Tipo.first.conceptos.last.tipos.last.cargos.last.persona
    banner = 'app/assets/images/banner.png'
    if eco == 1
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end

    ptotal = 0
    data = [%w(C.I NOMBRES CUENTA MONTO)]

    cargos = tipo.cargos

    cargos.each do |cargo|
      next unless cargo.disponible == false
      p = cargo.persona
      conperExtra = ''
      conExtra = ''
      total = 0
      total_deducciones = 0
      total_asignaciones = 0

      conperExtra = Conceptopersonal.find(conper) if conper && conper != '0' && conper != ''

      conExtra = Concepto.find(con) if con && con != '0' && con != ''
      if con || conper
        p.calculo true
      else
        p.calculo false
      end

      next unless p.valido == true
      next unless p.status != 'retirado'

      p.asignaciones.each do |c|
        condicion = false

        if c['clase_de_concepto'] == 0
          if con && con != '0' && con != ''
            condicion = (c['nombre'] == conExtra.nombre)
          end
          condicion = true if con == '' && c['extra'] == false
        else
          if conper && conper != '0' && conper != ''
            condicion = (c['nombre'] == conperExtra.nombre)
          end
          condicion = true if conper == '' && c['extra'] == false
        end
        next unless condicion
        total_asignaciones += c['valor'].to_f if p.status == 'activo'
      end
      p.deducciones.each do |c|
        condicion = false

        if c['clase_de_concepto'] == 0
          if con && con != '0' && con != ''
            condicion = (c['nombre'] == conExtra.nombre)
          end
          condicion = true if con == '' && c['extra'] == false
        else
          if conper && conper != '0' && conper != ''
            condicion = (c['nombre'] == conperExtra.nombre)
          end
          condicion = true if conper == '' && c['extra'] == false
        end
        next unless condicion
        total_deducciones += c['valor'].to_f if p.status == 'activo'
      end
      total = total_asignaciones - total_deducciones
      if p.status == 'activo'
        data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20], total]]
        ptotal += p.total
      else
        data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20], 0]]
    end
    end

    image banner, scale: 0.48, at: [37, 720]
    move_down 120
    text 'LISTADO DE DE DEPOSITOS BANCARIOS ', align: :center, size: 16, leading: 2
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 16, leading: 2
    text 'NOMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 16
    move_down 20
    data += [['TOTAL GENERAL', '', '', ptotal]]
    table data, header: true, cell_style: { size: 8 }, width: 517
    start_new_page
  end
end
