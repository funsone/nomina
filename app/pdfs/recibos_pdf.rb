class RecibosPdf < Prawn::Document


  def initialize(tipo, eco, con, conper)
    super(left_margin: 50)
    banner = 'app/assets/images/banner.png'
    if eco == 1
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end
    @cargos = tipo.cargos
    image banner, scale: 0.40, at: [37,720]
    move_down 100
    text 'NÓMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 14, leading: 2
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 14
    move_down 10
    table([[tipo.nombre.upcase]], cell_style: { border_width: 1, size: 8, :borders => [:top, :bottom]}, :width => 500 )
    table([["SEDE FUNSONE"]], cell_style: { border_width: 1, size: 8, :borders => [:bottom]}, :width => 500 )
    table([["","ASIGNACIÓN", "DEDUCCIÓN", "TOTAL A PAGAR"]],cell_style: { border_width: 0, size: 9, align: :right, font_style: :bold}, header: true, column_widths: [200,100, 100, 100], :width => 500)
ele=1
    @cargos.each do |s|
      s.persona_ahora
      next unless s.d == false
      p = s.p
      conperExtra = ''
      conExtra = ''
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


      table([["CÉDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]],cell_style: { border_width: 1, size: 8, :borders => [:top]}, header: true, column_widths: [80, 280, 140], :width => 500)
      table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA: #{p.cuenta.to_s[10..12]+'-'+p.cuenta.to_s[13..20]}", "SUELDO BÁSICO: #{ tr(p.cargo.sueldos.last.monto)}"]], cell_style: { border_width: 1, size: 8, :borders => [:bottom]}, header: true, width: 500, :column_widths => {0 => 170, 2 => 120})
      data = []
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
        data += [[c['nombre'].upcase, tr(c['valor']), '', '']]
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
        data += [[c['nombre'].upcase,'', tr(c['valor']), '']]
        total_deducciones += c['valor'].to_f
        end
      end
      data1 = [['', tr(total_asignaciones), tr(total_deducciones),tr(total_asignaciones - total_deducciones)]]
      if data!=[]
      table(data, header: true, width: 500, cell_style: { size: 8, border_width: 0, align: :right, :padding=>[2,5,2,5] }, column_widths: [200, 100, 100, 100]) do
          style(row(0..10).column(0), align: :left)
      end
      end
      table(data1, header: true, width: 500, cell_style: { size: 8, align: :right, border_width: 1, :borders => [:top, :bottom]}, column_widths: [200, 100, 100, 100])
if ele.modulo(4)==0
  start_new_page
end
  ele=ele+1
    end
  end
end
