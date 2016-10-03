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
                acu_aporte_e += BigDecimal.new(c['valor'].to_s)
                acu_aporte_p += BigDecimal.new(c['valor_patrono'].to_s)
                data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", tr(c['valor']).gsub!('.', ',' ), tr(c['valor_patrono']).gsub!('.', ',' ), tr((BigDecimal.new(c['valor'].to_s) + BigDecimal.new(c['valor_patrono'].to_s)).to_f).gsub!('.', ',' )]]
              else
                data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", '0,00', '0,00', '0,00']]
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
      table([["", "", "APORTE EMPLEADO", "APORTE PATRONO", "MONTO TOTAL"]],cell_style: { border_width: 0, size: 9, align: :center, font_style: :bold}, header: false, column_widths: [80, 210, 70, 70, 70], :width => 500, :position=> :center )
      table([[concepto.nombre.upcase]], cell_style: { border_width: 1, size: 9, align: :left, :borders=>[:top, :bottom]}, header: false, :width => 500, :position=> :center )
      data1= [['', concepto.nombre.upcase, tr(acu_aporte_e.to_f).gsub!('.', ',' ), tr(acu_aporte_p.to_f).gsub!('.', ',' ), tr((BigDecimal.new(acu_aporte_p.to_s)+ BigDecimal.new(acu_aporte_e.to_s)).to_f).gsub!('.', ',' )]]
      data2 = [['', "Nro. Empleados", pc ,'' , '']]
      if data!=[]
      table(data, header: false, cell_style: {border_width: 0, size: 8, align: :right} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center ) do
        style(row(0..200).column(2..4), padding: [5, 20, 5, 5])
        style(row(0..200).column(1), align: :left)
      end
      end
      if data1!=[]
      table(data1, header: false, cell_style: {border_width: 1, size: 9, align: :right, :borders =>[:top], font_style: :bold} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center ) do
        style(row(0).column(2..4), padding: [5, 20, 5, 5])
        style(row(0).column(1), align: :center)
      end
      end
      table(data2, header: false, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:bottom], font_style: :bold} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center )
      start_new_page
    end
    conceptosp = Conceptopersonal.all

    conceptosp.each do |conceptop|
    begin
      next unless Conceptopersonal.find(conper).nombre==conceptop.nombre

    rescue Exception

    end
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
        next unless p.cargo.tipo==tipo
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
              acu_aporte_e += BigDecimal.new(c['valor'].to_s)
              acu_aporte_p += BigDecimal.new(c['valor_patrono'].to_s)
              data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", tr(c['valor']).gsub!('.', ',' ), tr(c['valor_patrono']).gsub!('.', ',' ), tr((BigDecimal.new(c['valor'].to_s) + BigDecimal.new(c['valor_patrono'].to_s)).to_f).gsub!('.', ',' )]]
            else
              data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", '0,00', '0,00', '0,00']]
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
      table([["", "", "APORTE EMPLEADO", "APORTE PATRONO", "MONTO TOTAL"]],cell_style: { border_width: 0, size: 9, align: :center, font_style: :bold}, header: false, column_widths: [80, 210, 70, 70, 70], :width => 500, :position=> :center  )
      table([[conceptop.nombre.upcase]], cell_style: { border_width: 1, size: 9, align: :left, :borders=>[:top, :bottom]}, header: false, :width => 500, :position=> :center )
      data1 = [['', conceptop.nombre.upcase, tr(acu_aporte_e.to_f).gsub!('.', ',' ), tr(acu_aporte_p.to_f).gsub!('.', ',' ), tr((BigDecimal.new(acu_aporte_p.to_s)+ BigDecimal.new(acu_aporte_e.to_s)).to_f).gsub!('.', ',' )]]
      data2 = [['', "Nro. Empleados", pc ,'' , '']]
      if data!=[]
      table(data, header: false, cell_style: {border_width: 0, size: 8, align: :right} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center ) do
        style(row(0..200).column(2..4), padding: [5, 20, 5, 5])
        style(row(0..200).column(1), align: :left)
      end
      end
      if data1!=[]
      table(data1, header: false, cell_style: {border_width: 1, size: 9, align: :right, :borders =>[:top], font_style: :bold} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center ) do
      style(row(0).column(2..4), padding: [5, 20, 5, 5])
      style(row(0).column(1), align: :center)
      end
      end
      table(data2, header: false, cell_style: {border_width: 1, size: 9, align: :center, :borders =>[:bottom], font_style: :bold} , column_widths: [70, 220, 70, 70, 70], width: 500, :position=> :center )
      start_new_page
    end
  end
end
