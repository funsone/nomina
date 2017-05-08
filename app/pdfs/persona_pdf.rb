class PersonaPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  extend ActionView::Helpers::NumberHelper
  def initialize(p, eco)
    super(left_margin: 50)

    banner = 'app/assets/images/banner.png'
    if eco == 1
      font_families.update("eco" => {
          :normal => "public/fonts/eco.ttf",
          :bold => "public/fonts/eco.ttf"
        })
      font 'eco'
      banner = 'app/assets/images/banner_bn.png'
    end

    image banner, scale: 0.50, at: [10, 720]
    move_down 100
    text 'NÓMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 14, leading: 2
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 14
    move_down 10
    table([["CÉDULA: #{p.cedula}", "NOMBRES: #{p.apellidos.upcase}, #{p.nombres.upcase}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio.strftime("%d-%m-%Y")}"]], cell_style: { border_width: 1, size: 8, :borders => [:top] }, header: false, column_widths: [85, 270, 145], width: 500)
    table([["CARGO: <font size='7'>#{p.cargo.nombre.upcase}</font>", "BANCO DE VENEZUELA: #{p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20]}", "SUELDO BÁSICO: #{number_with_delimiter(tr(p.cargo.sueldos.last.monto))}"]], cell_style: { :inline_format => true, border_width: 0, size: 8, :padding => [0, 5, 0, 5]}, header: false, width: 500, column_widths: { 0 => 170, 2 => 145 })
    table([["UBICACIÓN: Sede FUNSONE", "ESTADO EMPLEADO: #{p.status.capitalize}", "", ""]], cell_style: { border_width: 1, size: 8, :borders => [:bottom]  }, header: false, width: 500)
    move_down 10
    table([["","ASIGNACIÓN", "DEDUCCIÓN", "TOTAL A PAGAR"]],cell_style: { border_width: 1, size: 10, align: :right, :borders => [:bottom], font_style: :bold}, header: false, column_widths: [200,100, 100, 100], :width => 500)
    data = []
    p.asignaciones.each do |c|
      data += [[c['nombre'].upcase, number_with_delimiter(tr(c['valor'])), '', '']]
    end
    p.deducciones.each do |c|
      data += [[c['nombre'].upcase, '', number_with_delimiter(tr(c['valor'])), '']]
    end
    data1 = [['',number_with_delimiter(tr(p.total_asignaciones.to_f)),number_with_delimiter(tr(p.total_deducciones.to_f)), number_with_delimiter(tr(p.total.to_f))]]
    if data!=[]
    table(data, header: false, width: 500, cell_style: { size: 9, border_width: 0, align: :right}, column_widths: [200, 100, 100, 100]) do
        style(row(0..10).column(0), align: :left)
    end
    end
    table(data1, header: false, width: 500, cell_style: { size: 9, align: :right, border_width: 1, :borders => [:top, :bottom]}, column_widths: [200, 100, 100, 100])
    p.calculo true
    cc = [p.asignaciones, p.deducciones]
    i = 0
    cc.each do |ccc|
      ccc.each do |c|
        next unless c['extra']
        start_new_page
        image banner, scale: 0.50, at: [10, 720]
        move_down 100
        text 'NÓMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 14, leading: 2
        text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 14
        move_down 10
        table([["CÉDULA: #{p.cedula}", "NOMBRES: #{p.apellidos.upcase}, #{p.nombres.upcase}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio.strftime("%d-%m-%Y")}"]], cell_style: { border_width: 1, size: 8, :borders => [:top]}, header: false, column_widths: [85, 270, 145], width: 500)
        table([["CARGO: <font size='7'>#{p.cargo.nombre.upcase}</font>", "BANCO DE VENEZUELA: #{p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20]}", "SUELDO BÁSICO: #{number_with_delimiter(tr(p.cargo.sueldos.last.monto))}"]], cell_style: { :inline_format => true, border_width: 0, size: 8, :padding => [0, 5, 0, 5]}, header: false, width: 500, column_widths: { 0 => 170, 2 => 145 })
        table([["UBICACIÓN: Sede FUNSONE", "ESTADO EMPLEADO: #{p.status.capitalize}", "", ""]], cell_style: { border_width: 1, size: 8, :borders => [:bottom]}, header: false, width: 500)
        move_down 10
        table([["","ASIGNACIÓN", "DEDUCCIÓN", "TOTAL A PAGAR"]],cell_style: { border_width: 1, size: 10, align: :right, :borders => [:bottom], font_style: :bold}, header: false, column_widths: [200,100, 100, 100], :width => 500)
        data = []

        if i == 0 || i == 2
          data += [[c['nombre'].upcase, number_with_delimiter(tr(c['valor'])), '',number_with_delimiter(tr(c['valor']))]]
          data1 = [['', number_with_delimiter(tr(c['valor'])), '0,00', number_with_delimiter(tr(c['valor']))]]
        else
          data += [[c['nombre'].upcase, '',number_with_delimiter(tr(c['valor'])), number_with_delimiter(tr(c['valor']))]]
          data1 = [['', '0,00',number_with_delimiter(tr(c['valor'])), number_with_delimiter(tr(c['valor']))]]
        end
        if data!=[]
        table(data, header: false, width: 500, cell_style: { size: 9, border_width: 0, align: :right}, column_widths: [200, 100, 100, 100]) do
            style(row(0..1).column(0), align: :left)
        end
        end
        table(data1, header: false, width: 500, cell_style: { size: 9, align: :right, border_width: 1, :borders => [:top, :bottom]}, column_widths: [200, 100, 100, 100])
      end
      i += 1
    end
      move_down 100
    if p.cargo.tipo.nombre == 'contratados'
        data2 = [['Elaborado por:            Coord. RRHH','','Revisado por:         Coord. Admon. y Finanzas','','Aprobado por: Presidencia', '', 'Firmado por: Empleado']]
      table(data2, header: false, cell_style: {border_width: 1, size: 10, align: :center, font_style: :bold} , column_widths: [120, 6, 122, 6, 120, 6, 120], width: 500) do
        column(0).borders = [:top]
        column(1).borders = []
        column(2).borders = [:top]
        column(3).borders = []
        column(4).borders = [:top]
        column(5).borders = []
        column(6).borders = [:top]
      end

    end
  end
end
