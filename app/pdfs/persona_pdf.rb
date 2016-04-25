class PersonaPdf <Prawn::Document
def initialize(p)

  super(left_margin: 50)

image "app/assets/images/banner.png"
  text "NOMINA PERSONAL "+p.cargo.tipo.nombre.upcase,align: :center, size: 18
  text $dic["quincena"].key($quincena).upcase+" DE "+ $ahora.strftime("%^B DE %y"),align: :center, size: 18
  table([["CEDULA: #{p.cedula}","NOMBRES: #{p.nombres},#{p.apellidos}","FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]],:cell_style => { :border_width => 0,size:10 }, :header => true)
  table([["CARGO: #{p.cargo.nombre.upcase}","BANCO DE VENEZUELA #{p.cuenta}","SUEDO BASICO: #{p.cargo.sueldos.last.monto}"]],:cell_style => { :border_width => 0,size:10 }, :header => true)
  table([[ "UBICACION: SEDE FUNSONE"]],:cell_style => { :border_width => 0,size:10 })
  move_down 20
data = [["CONCEPTO","ASIGNACION","DEDUCCION","TOTAL"]]


   p.asignaciones.each do |c|
data+=[[c['nombre'].upcase,c['valor'],"",""]]

  end
  p.deducciones.each do |c|
data+=[[c['nombre'].upcase,"",c['valor'],""]]

 end
   data+=[["",(p.total_asignaciones - 0.0005).round(2).to_s,(p.total_deducciones - 0.0005).round(2).to_s , ((p.total) - 0.0005).round(2).to_s]]


table(data, :header => true,width: 500,:cell_style => { :size => 10 })
image "app/assets/images/banner.png"
end
end
