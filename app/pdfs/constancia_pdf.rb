class ConstanciaPdf < Prawn::Document
  def initialize(p, eco)
    super(left_margin: 100, top_margin: 50, right_margin: 100)
    banner = 'app/assets/images/banner.png'
    banner_abajo = 'app/assets/images/banner_abajo.png'
    tam = 0
    if eco == 1
      font_families.update("eco" => {
          :normal => "public/fonts/eco.ttf",
          :bold => "public/fonts/eco.ttf"
        })
      font 'eco'
      tam = 2
      banner = 'app/assets/images/banner_bn.png'
      banner_abajo = 'app/assets/images/banner_abajo_bn.png'
    end
    image banner, scale: 0.40
    move_down 40
    text '<b>CONSTANCIA DE TRABAJO</b>', align: :center, size: 16, :inline_format => true
    move_down 40
    titulo = p.sexo==0 ? 'el ciudadano' : 'la ciudadana'
    nombres = (p.nombres + ' ' + p.apellidos).upcase
    fecha = p.contrato.fecha_inicio.strftime('%d de ' + $dic['meses'].key(p.contrato.fecha_inicio.month).capitalize + ' de %Y')
    cedula = $dic['tipos_de_cedula'].key(p.tipo_de_cedula) + p.cedula.to_s
    text "Por medio de la presente hacemos constar que #{titulo} <b><u>#{nombres}</u></b>, titular de la Cédula de Identidad N° <b>#{cedula}</b> trabaja en esta Institución desde el <b>#{fecha}</b>, desempeñando el cargo de <b>#{p.cargo.nombre.upcase}</b> percibiendo un sueldo mensual de Bolívares (Bs. #{tr(p.cargo.sueldos.last.monto).gsub!('.', ',' )}) en el horario comprendido entre las #{Setting.jornada_de_trabajo_inicio} y #{Setting.jornada_de_trabajo_fin}.", :inline_format => true, align: :justify, size: 14, leading: 7
    move_down 20
    text "Constancia que expedimos el #{$ahora.strftime('%d de ' + $dic['meses'].key($ahora.month).capitalize + ' de %Y')}.", align: :justify, size: 14, leading: 7
    move_down 70
    table([[""]], cell_style: {border_width: 1, :borders =>[:bottom]}, :position => :center, width: 250)
    move_down 5
    text Setting.titulo_coordinador + ' ' + Setting.nombres_coordinador, align: :center, size: 14
    text "Cédula Identidad " + Setting.cedula_coordinador, align: :center, size: 14
    text 'Coordinador de Recursos Humanos', align: :center, size: 14

    image banner_abajo, scale: 0.25, align: :center, at: [bounds.left, 85]
  end
end
