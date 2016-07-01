class ConceptosPdf < Prawn::Document
  def initialize(tipo, eco, con, conper)
    super(left_margin: 20, top_margin: 30, right_margin: 20)
    # Tipo.first.conceptos.last.tipos.last.cargos.last.persona
    banner = 'app/assets/images/banner.png'
    if eco == 1
      font_families.update("eco" => {
          :normal => "public/fonts/eco.ttf",
          :bold => "public/fonts/eco.ttf"
        })
      font 'eco'
      banner = 'app/assets/images/banner_bn.png'
    end
    conceptos = tipo.conceptos

    conceptos.each do |concepto|
      tipos = concepto.tipos

      conceptoExtra = concepto
      next if con == '0'
      conceptoExtra = Concepto.find(con) if con && con != ''

      next unless conceptoExtra.id == concepto.id
      acu_aporte_e = 0
      acu_aporte_p = 0
      pc = 0
      data = []

        cargos = tipo.cargos

        cargos.each do |cargo|


          cargo.persona_ahora
          next unless cargo.d == false
          p = cargo.p

          if con != ''
            p.calculo true
          else

            p.calculo false
          end
          next unless (p.contrato.tipo_de_contrato != 2) || (p.total > 0 && p.contrato.tipo_de_contrato == 2)
          next unless p.valido == true
          next unless p.status != 'retirado'
          cc = [p.asignaciones, p.deducciones]
          cc.each do |ccc|
            ccc.each do |c|
              next unless c['nombre'] == concepto.nombre && c['clase_de_concepto'] == 0
              pc += 1
              if p.status == 'activo'
                acu_aporte_e += c['valor'].to_d
                acu_aporte_p += c['valor_patrono'].to_d
                data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", tr(c['valor']), tr(c['valor_patrono']), tr((c['valor'].to_d + c['valor_patrono'].to_d))]]
              else
                data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", '0.00', '0.00', '0.00']]
              end
            end
          end
        end

      next unless pc > 0
      image banner, scale: 0.40, at: [62, 720]
      move_down 100
      text 'LISTADO DE DEDUCCIONES ', align: :center, size: 14, leading: 2
      text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 14, leading: 2
      text 'NÓMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 14, leading: 2
      text concepto.nombre.upcase, size: 14, align: :center, leading: 2
      move_down 10
      table([["", "", "APORTE EMPLEADO", "APORTE PATRONO", "MONTO TOTAL"]],cell_style: { border_width: 0, size: 9, align: :center, font_style: :bold}, header: true, column_widths: [80, 210, 70, 70, 70], :width => 500, :position=> :center )
      table([[concepto.nombre.upcase]], cell_style: { border_width: 1, size: 9, align: :left, :borders=>[:top, :bottom]}, header: true, :width => 500, :position=> :center )
      data1= [['', concepto.nombre.upcase, tr(acu_aporte_e), tr(acu_aporte_p), tr(acu_aporte_p + acu_aporte_e)]]
      data2 = [['', "Nro. Empleados", pc ,'' , '']]
      table(data, header: true, cell_style: {border_width: 0, size: 8, align: :center} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      table(data1, header: true, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:top], font_style: :bold} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      table(data2, header: true, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:bottom], font_style: :bold} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      start_new_page
    end
    conceptosp = Conceptopersonal.all

    conceptosp.each do |conceptop|
      registros = conceptop.registrosconceptos
      conceptoExtra = conceptop
      next if conper == '0'
      conceptoExtra = Conceptopersonal.find(conper) if conper != ''
      acu_aporte_e = 0
      acu_aporte_p = 0
      pc = 0
      data = []
      registros.each do |registro|
        p = registro.persona
        if conper != ''
          p.calculo true
        else
          p.calculo false
        end
        next unless p.valido == true
        cc = [p.asignaciones, p.deducciones]
        cc.each do |ccc|
          ccc.each do |c|
            next unless c['nombre'].casecmp(conceptop.nombre.upcase).zero? && c['clase_de_concepto'] == 1
            pc += 1
            if p.status == 'activo'
              acu_aporte_e += c['valor'].to_d
              acu_aporte_p += c['valor_patrono'].to_d
              data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", tr(c['valor']), tr(c['valor_patrono']), tr(c['valor'].to_d + c['valor_patrono'].to_d)]]
            else
              data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", '0.00', '0.00', '0.00']]
            end
          end
        end
      end
      next unless pc > 0
      image banner, scale: 0.40, at: [62, 720]
      move_down 100
      text 'LISTADO DE DEDUCCIONES ', align: :center, size: 14, leading: 2
      text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 14, leading: 2
      text 'NÓMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 14, leading: 2
      text conceptop.nombre.upcase, size: 14, align: :center, leading: 2
      move_down 10
      table([["", "", "APORTE EMPLEADO", "APORTE PATRONO", "MONTO TOTAL"]],cell_style: { border_width: 0, size: 9, align: :center, font_style: :bold}, header: true, column_widths: [80, 210, 70, 70, 70], :width => 500, :position=> :center  )
      table([[conceptop.nombre.upcase]], cell_style: { border_width: 1, size: 9, align: :left, :borders=>[:top, :bottom]}, header: true, :width => 500, :position=> :center )
      data1 = [['', conceptop.nombre.upcase, tr(acu_aporte_e), tr(acu_aporte_p), tr(acu_aporte_p + acu_aporte_e)]]
      data2 = [['', "Nro. Empleados", pc ,'' , '']]
      table(data, header: true, cell_style: {border_width: 0, size: 8, align: :center} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      table(data1, header: true, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:top], font_style: :bold} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      table(data2, header: true, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:bottom], font_style: :bold} , column_widths: [80, 210, 70, 70, 70], width: 500, :position=> :center )
      start_new_page
    end
  end
end
