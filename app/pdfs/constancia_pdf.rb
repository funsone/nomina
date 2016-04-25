class ConstanciaPdf <Prawn::Document
def initialize(p)

  super(left_margin: 100, top_margin: 50, right_margin: 100)

image "app/assets/images/banner.png"
move_down 40
  text "CONSTANCIA DE TRABAJO",align: :center, size: 16, style: :bold
  move_down 40
  titulo=p.sexo ? "el ciudadano" : "la ciudadana"
  nombres=(p.nombres+" "+p.apellidos).upcase
  fecha=p.contrato.fecha_inicio.strftime('%d de '+$dic['meses'].key(p.contrato.fecha_inicio.month).capitalize+' de %Y')
  cedula= $dic['tipos_de_cedula'].key(p.tipo_de_cedula)+p.cedula.to_s
  text "Por medio de la presente hacemos constar que #{titulo} #{nombres}, titular de la Cédula de Identidad N° #{cedula} trabaja en esta Institución desde el #{fecha}, desempeñando el cargo de #{p.cargo.nombre.upcase} percibiendo un sueldo mensual de Bolívares (Bs. #{p.cargo.sueldos.last.monto}) en el horario comprendido entre las 8:00 a.m. y 3:30 p.m. ",align: :justify, size: 16,:leading => 7
  move_down 20
  text "Constancia que expedimos el #{$ahora.strftime('%d de '+$dic['meses'].key($ahora.month).capitalize+' de %Y')}.",align: :justify, size: 16, :leading => 7
move_down 80
 text "T.S.U Alejandro Luis Rodríguez
Cédula Identidad V-8.397.611
Coordinador de Recursos Humanos", align: :center, size: 16

image "app/assets/images/banner_abajo.png", :scale => 0.25, align: :center, :at => [bounds.left, 85]
end
end
