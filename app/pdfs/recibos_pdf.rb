class RecibosPdf < Prawn::Document
    def initialize(tipo, eco)
        super(left_margin: 50)
        banner = 'app/assets/images/banner.png'
        if eco == 1
            font 'public/fonts/eco.ttf'
            banner = 'app/assets/images/banner_bn.png'
        end
        @cargos = tipo.cargos
        @cargos.each do |s|
            p = s.persona
            p.calculo

            image banner, scale: 0.54, align: :center
            move_down 30
            text 'NOMINA PERSONAL ' + p.cargo.tipo.nombre.upcase, align: :center, size: 16
            text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 18
            table([["CEDULA: #{p.cedula}", "NOMBRES: #{p.nombres},#{p.apellidos}", "FECHA DE INGRESO: #{p.contrato.fecha_inicio}"]], cell_style: { border_width: 0, size: 10 }, header: true)
            table([["CARGO: #{p.cargo.nombre.upcase}", "BANCO DE VENEZUELA #{p.cuenta}", "SUEDO BASICO: #{p.cargo.sueldos.last.monto}"]], cell_style: { border_width: 0, size: 10 }, header: true)
            table([['UBICACION: SEDE FUNSONE']], cell_style: { border_width: 0, size: 10 })
            move_down 20
            data = [%w(CONCEPTO ASIGNACION DEDUCCION TOTAL)]

            p.asignaciones.each do |c|
                data += [[c['nombre'].upcase, c['valor'], '', '']]
            end
            p.deducciones.each do |c|
                data += [[c['nombre'].upcase, '', c['valor'], '']]
            end
            data += [['', (p.total_asignaciones - 0.0005).round(2).to_s, (p.total_deducciones - 0.0005).round(2).to_s, (p.total - 0.0005).round(2).to_s]]

            table(data, header: true, width: 500, cell_style: { size: 10 })
            start_new_page
        end
    end
end
