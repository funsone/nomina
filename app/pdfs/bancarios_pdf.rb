class BancariosPdf < Prawn::Document
  def initialize(tipo, eco, con, conper)
    super(left_margin: 50, top_margin: 30, right_margin: 20)
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

    ptotal = 0
    data= []
    cargos = tipo.cargos
    pc=0
    cargos.each do |cargo|
      cargo.persona_ahora
      next unless cargo.d == false
      p = cargo.p
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
        total_asignaciones += BigDecimal.new(c['valor'].to_s) if p.status == 'activo'
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
        total_deducciones += BigDecimal.new(c['valor'].to_s) if p.status == 'activo'
      end
      total = (BigDecimal.new(total_asignaciones.to_s) - BigDecimal.new(total_deducciones.to_s))
      pc=pc+1
      if p.status == 'activo'
if total != 0.0
        data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20], tr(total.to_f).gsub!('.', ',' )]]
        ptotal += BigDecimal.new(total.to_s)
     end
      else
        data += [[p.cedula.to_s, "#{p.apellidos.upcase} #{p.nombres.upcase}", p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20], "0,00"]]
      end
    end
return unless pc>0
    image banner, scale: 0.40, at: [37, 720]
    move_down 100
    text 'LISTADO DE DEPÓSITOS BANCARIOS ', align: :center, size: 14, leading: 2
    text 'NÓMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 14
      text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y')+' - FUNSONE', align: :center, size: 14, leading: 2
    move_down 20
    table([["CÉDULA","NOMBRES", "CUENTA", "MONTO"]],cell_style: { border_width: 1, size: 9, align: :left, :borders=>[:top, :bottom], font_style: :bold}, header: false, column_widths: [80,260, 80, 80], :width => 500, :position => :center)
    data1 = [['', 'TOTAL GENERAL', '',tr(ptotal.to_f).gsub!('.', ',' )]]
    if data!=[]
    table(data.sort_by{|x| x[0].to_i}, header: false, cell_style: { size: 8, border_width:1, :borders=>[:bottom], align: :right }, width: 500, column_widths: [80, 260, 80, 80], :position => :center) do
    style(row(0..200).column(3), padding: [5, 20, 5, 5])
    style(row(0..200).column(1..2), align: :left)
    end
    end
    move_down 5
    if data1!=[]
    table(data1, header: false, width: 500, cell_style: { size: 9, align: :left, border_width: 1, :borders => [:top], font_style: :bold}, column_widths: [80, 260, 80, 80], :position => :center) do
    style(row(0).column(3), padding: [5, 20, 5, 5])
    style(row(0).column(3), align: :right)
    end
    end
  end
end
