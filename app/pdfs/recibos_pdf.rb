class RecibosPdf < Prawn::Document
  def truncar(n)
    ('%0.2f' % n).to_f
  end

  def initialize(tipo, eco, con, conper)
    super(left_margin: 50)
    banner = 'app/assets/images/banner.png'
    if eco == 1
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end
    @cargos = tipo.cargos
    @cargos.each do |s|
      next unless s.disponible == false
      p = s.persona
      conperExtra = ''
      conExtra = ''
      total = 0
      total_deducciones = 0
      total_asignaciones = 0
      if conper && conper != '0' && conper != ''
        conperExtra = Conceptopersonal.find(conper)
      end
      conExtra = Concepto.find(con) if con && con != '0' && con != ''
      if con || conper
        p.calculo true
      else

        p.calculo false
      end
      next unless p.valido == true
      next unless p.status != 'retirado'
      next unless (p.contrato.tipo_de_contrato != 2) || (p.total > 0 && p.contrato.tipo_de_contrato == 2)
      image banner, scale: 0.48, at: [37,720]
      move_down 120
      text 'NOMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 16
      text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 18
      table([["CEDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]], cell_style: { border_width: 0, size: 10 }, header: true)
      table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA #{p.cuenta}", "SUEDO BASICO: #{p.cargo.sueldos.last.monto}"]], cell_style: { border_width: 0, size: 10 }, header: true)
      table([["UBICACION: Sede FUNSONE   ESTADO EMPLEADO: #{p.status.capitalize}"]], cell_style: { border_width: 0, size: 10 })
      move_down 20
      data = [%w(CONCEPTO ASIGNACION DEDUCCION TOTAL)]

      p.asignaciones.each do |c|
        condicion = false

        if c['clase_de_concepto']==0
          if con && con != '0' && con!=''
            condicion = (c['nombre'] == conExtra.nombre)
          end
          condicion = true if (con == '' and c['extra']==false)
        else
          if conper && conper != '0' && conper!=''
            condicion = (c['nombre'] == conperExtra.nombre)
          end
          condicion = true if (conper == '' and c['extra']==false)
        end
        next unless condicion
        if p.status == 'activo'
        data += [[c['nombre'].upcase, c['valor'], '', '']]
        total_asignaciones += c['valor'].to_f
        end
       end
      p.deducciones.each do |c|
        condicion = false

        if c['clase_de_concepto']==0
          if con && con != '0' && con!=''
            condicion = (c['nombre'] == conExtra.nombre)
          end
          condicion = true if (con == '' and c['extra']==false)
        else
          if conper && conper != '0' && conper!=''
            condicion = (c['nombre'] == conperExtra.nombre)
          end
          condicion = true if (conper == '' and c['extra']==false)
        end
        next unless condicion
        if p.status == 'activo'
        data += [[c['nombre'].upcase, c['valor'], '', '']]
        total_deducciones += c['valor'].to_f
        end
      end
      data += [['', truncar(total_asignaciones).to_s, truncar(total_deducciones).to_s, truncar(total_asignaciones - total_deducciones).to_s]]

      table(data, header: true, width: 500, cell_style: { size: 10 })
      start_new_page
    end
  end
end
