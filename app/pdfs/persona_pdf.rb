class PersonaPdf < Prawn::Document
  def initialize(p, eco)
    super(left_margin: 50)

    banner = 'app/assets/images/banner.png'
    if eco == 1
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end

    image banner, scale: 0.48, at: [37, 720]
    move_down 120
    text 'NÓMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 16, leading: 2
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 16
    move_down 10
    table([["CÉDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]], cell_style: { border_width: 0, size: 10 }, header: true, column_widths: [100, 280, 120], width: 500)
    table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA: #{p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20]}", "SUELDO BÁSICO: #{'%.2f' % truncar(p.cargo.sueldos.last.monto)}"]], cell_style: { border_width: 0, size: 10 }, header: true, width: 500, column_widths: { 0 => 170, 2 => 120 })
    table([["UBICACIÓN: Sede FUNSONE", "ESTADO EMPLEADO: #{p.status.capitalize}"]], cell_style: { border_width: 0, size: 10 }, header: true)
    move_down 20
    data = [%w(CONCEPTO ASIGNACION DEDUCCION TOTAL)]

    p.asignaciones.each do |c|
      data += [[c['nombre'].upcase, '%.2f' % c['valor'], '', '']]
    end
    p.deducciones.each do |c|
      data += [[c['nombre'].upcase, '', '%.2f' % c['valor'], '']]
    end
    data += [['','%.2f' % truncar(p.total_asignaciones),'%.2f' % truncar(p.total_deducciones), '%.2f' % truncar(p.total)]]

    table(data, header: true, width: 515, cell_style: { size: 10 })

    p.calculo true
    cc = [p.asignaciones, p.deducciones]
    i = 0
    cc.each do |ccc|
      ccc.each do |c|
        next unless c['extra']
        start_new_page
        image banner, scale: 0.48, at: [37, 720]
        move_down 120
        text 'NÓMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 16, leading: 2
        text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 16
        move_down 10
        table([["CÉDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]], cell_style: { border_width: 0, size: 10 }, header: true, column_widths: [100, 280, 120], width: 500)
        table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA: #{p.cuenta.to_s[10..12] + '-' + p.cuenta.to_s[13..20]}", "SUELDO BÁSICO: #{ '%.2f' % p.cargo.sueldos.last.monto}"]], cell_style: { border_width: 0, size: 10 }, header: true, width: 500, column_widths: { 0 => 170, 2 => 120 })
        table([["UBICACIÓN: SEDE FUNSONE", "ESTADO EMPLEADO: #{p.status.capitalize}"]], cell_style: { border_width: 0, size: 10 }, header: true)
        move_down 20
        data = [%w(CONCEPTO ASIGNACION DEDUCCION TOTAL\ A\ PAGAR)]

        if i == 0 || i == 2
          data += [[c['nombre'].upcase, '%.2f' % c['valor'], '','%.2f' % c['valor']]]
          data += [['', '%.2f' % c['valor'], '0.00', '%.2f' % c['valor']]]
        else
          data += [[c['nombre'].upcase, '','%.2f' % c['valor'], '%.2f' % c['valor']]]
          data += [['', '0.00','%.2f' % c['valor'], '%.2f' % c['valor']]]
        end

        table(data, header: true, width: 515, cell_style: { size: 10 })
      end
      i += 1
    end
  end
end
