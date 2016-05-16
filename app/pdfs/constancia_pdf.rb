class ConstanciaPdf < Prawn::Document
  def initialize(p, eco)
    super(left_margin: 100, top_margin: 50, right_margin: 100)
    banner = 'app/assets/images/banner.png'
    banner_abajo = 'app/assets/images/banner_abajo.png'
    tam = 0
    if eco == 1
      font 'public/fonts/eco.ttf'
      tam = 2
      banner = 'app/assets/images/banner_bn.png'
      banner_abajo = 'app/assets/images/banner_abajo_bn.png'
    end
    image banner, scale: 0.45
    move_down 40
    text 'CONSTANCIA DE TRABAJO', align: :center, size: 16 - tam
    move_down 40
    titulo = p.sexo ? 'el ciudadano' : 'la ciudadana'
    nombres = (p.nombres + ' ' + p.apellidos).upcase
    fecha = p.contrato.fecha_inicio.strftime('%d de ' + $dic['meses'].key(p.contrato.fecha_inicio.month).capitalize + ' de %Y')
    cedula = $dic['tipos_de_cedula'].key(p.tipo_de_cedula) + p.cedula.to_s
    text "Por medio de la presente hacemos constar que #{titulo} #{nombres}, titular de la Cédula de Identidad N° #{cedula} trabaja en esta Institución desde el #{fecha}, desempeñando el cargo de #{p.cargo.nombre.upcase} percibiendo un sueldo mensual de Bolívares (Bs. #{p.cargo.sueldos.last.monto}) en el horario comprendido entre las #{Setting.jornada_de_trabajo_inicio} y #{Setting.jornada_de_trabajo_fin}.", align: :justify, size: 16 - tam, leading: 7
    move_down 20
    text "Constancia que expedimos el #{$ahora.strftime('%d de ' + $dic['meses'].key($ahora.month).capitalize + ' de %Y')}.", align: :justify, size: 16 - tam, leading: 7
    move_down 80
    text Setting.titulo_coordinador + ' ' + Setting.nombres_coordinador, align: :center, size: 16 - tam
    text "Cédula Identidad " + Setting.cedula_coordinador, align: :center, size: 16 - tam
    text 'Coordinador de Recursos Humanos', align: :center, size: 16 - tam

    image banner_abajo, scale: 0.25, align: :center, at: [bounds.left, 85]
  end
end
