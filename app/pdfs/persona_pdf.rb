class PersonaPdf < Prawn::Document
  def truncar(n)
    ('%0.2f' % n).to_f
  end

  def initialize(p, eco)
    super(left_margin: 50)

    banner = 'app/assets/images/banner.png'
    if eco == 1
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end

    image banner, scale: 0.48, at: [37,720]
    move_down 30
    text 'NOMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 16
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 18
    table([["CEDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]], cell_style: { border_width: 0, size: 10 }, header: true)
    table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA #{p.cuenta.to_s[10..12]+'-'+p.cuenta.to_s[13..20]}", "SUEDO BASICO: #{p.cargo.sueldos.last.monto}"]], cell_style: { border_width: 0, size: 10 }, header: true)
    table([["UBICACION: Sede FUNSONE   ESTADO EMPLEADO: #{p.status.capitalize}"]], cell_style: { border_width: 0, size: 10 })
    move_down 20
    data = [%w(CONCEPTO ASIGNACION DEDUCCION TOTAL)]

    p.asignaciones.each do |c|
      data += [[c['nombre'].upcase, c['valor'], '', '']]
    end
    p.deducciones.each do |c|
      data += [[c['nombre'].upcase, '', c['valor'], '']]
    end
    data += [['', truncar(p.total_asignaciones).to_s, truncar(p.total_deducciones).to_s, truncar(p.total).to_s]]

    table(data, header: true, width: 500, cell_style: { size: 10 })
  end
end
