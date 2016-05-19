class BancariosPdf < Prawn::Document
  def initialize(tipo, eco)
    super(left_margin: 50, top_margin: 30, right_margin: 20)
    # Tipo.first.conceptos.last.tipos.last.cargos.last.persona
    banner = 'app/assets/images/banner.png'
    if eco == 4
      font 'public/fonts/eco.ttf'
      banner = 'app/assets/images/banner_bn.png'
    end

    ptotal = 0
    data = [%w(C.I NOMBRES CUENTA MONTO)]

    cargos = tipo.cargos

    cargos.each do |cargo|
      next unless cargo.disponible == false
      p = cargo.persona
      p.calculo
      next unless p.valido == true
      data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", p.cuenta.to_s, p.total]]
      ptotal += p.total
    end

    image banner, scale: 0.54, align: :center
    move_down 20
    text 'LISTADO DE DE DEPOSITOS BANCARIOS ', align: :center, size: 16, leading: 2
    text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 16, leading: 2
    text 'NOMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 16
    move_down 20
    data += [['TOTAL GENERAL', '', '', ptotal]]
    table data, header: true, cell_style: { size: 8 }
    start_new_page
  end
end
