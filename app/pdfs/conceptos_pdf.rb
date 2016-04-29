class ConceptosPdf < Prawn::Document
    def initialize(tipo, eco)
        super(left_margin: 20, top_margin: 30, right_margin: 20)
        # Tipo.first.conceptos.last.tipos.last.cargos.last.persona
        banner = 'app/assets/images/banner.png'
        if eco == 4
            font 'public/fonts/eco.ttf'
            banner = 'app/assets/images/banner_bn.png'
        end
        conceptos = tipo.conceptos

        conceptos.each do |concepto|
            tipos = concepto.tipos

            acu_aporte_e = 0
            acu_aporte_p = 0
            pc = 0
            data = [%w(C.I NOMBRES APORTE\ EMPLEADO APORTE\ EMPLEADOR TOTAL)]

            tipos.each do |tipoo|
                cargos = tipoo.cargos

                cargos.each do |cargo|
                    p = cargo.persona
                    p.calculo
                    p.asignaciones.each do |c|
                        next unless c['nombre'] == concepto.nombre
                        pc += 1
                        acu_aporte_e += c['valor'].to_d
                        acu_aporte_p += c['valor_patrono'].to_d
                        data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", c['valor'], c['valor_patrono'], (c['valor'].to_d + c['valor_patrono'].to_d).to_s]]
                    end
                    p.deducciones.each do |c|
                        next unless c['nombre'] == concepto.nombre
                        pc += 1
                        acu_aporte_e += c['valor'].to_d
                        acu_aporte_p += c['valor_patrono'].to_d
                        data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", c['valor'], c['valor_patrono'], (c['valor'].to_d + c['valor_patrono'].to_d).to_s]]
                    end
                end
            end
            next unless pc > 0
            image banner, scale: 0.54, align: :center
            text 'LISTADO DE CONCEPTOS ', align: :center, size: 16
            text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 18
            text 'NOMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 16

            text concepto.nombre, size: 18, align: :center
            data += [['TOTAL', concepto.nombre, acu_aporte_e.to_s, acu_aporte_p.to_s, (acu_aporte_p + acu_aporte_e).to_s]]
            table data, header: true, cell_style: { size: 8 }
            start_new_page
        end
        conceptosp = Conceptopersonal.all

        conceptosp.each do |conceptop|
            @registros = conceptop.registrosconceptos
            acu_aporte_e = 0
            acu_aporte_p = 0
            pc = 0
            data = [%w(C.I NOMBRES APORTE\ EMPLEADO APORTE\ EMPLEADOR TOTAL)]
            @registros.each do |registro|
                p = registro.persona
                next unless p.cargo.tipo.id == tipo.id
                p.calculo
                p.asignaciones.each do |c|
                    next unless c['nombre'] == conceptop.nombre
                    pc += 1
                    acu_aporte_e += c['valor'].to_d
                    acu_aporte_p += c['valor_patrono'].to_d
                    data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", c['valor'], c['valor_patrono'], (c['valor'].to_d + c['valor_patrono'].to_d).to_s]]
                end
                p.deducciones.each do |c|
                    next unless c['nombre'] == conceptop.nombre
                    pc += 1
                    acu_aporte_e += c['valor'].to_d
                    acu_aporte_p += c['valor_patrono'].to_d
                    data += [[p.cedula.to_s, "#{p.nombres} #{p.apellidos}", c['valor'], c['valor_patrono'], (c['valor'].to_d + c['valor_patrono'].to_d).to_s]]
                end
            end
            next unless pc > 0
            image banner, scale: 0.54, align: :center
            text 'LISTADO DE CONCEPTOS ', align: :center, size: 16
            text $dic['quincena'].key($quincena).upcase + 'DE ' + $dic['meses'].key($ahora.month) + $ahora.strftime(' DE %Y'), align: :center, size: 18
            text 'NOMINA PERSONAL ' + tipo.nombre.upcase, align: :center, size: 16
            text conceptop.nombre, size: 18, align: :center
            data += [['TOTAL', conceptop.nombre, acu_aporte_e.to_s, acu_aporte_p.to_s, (acu_aporte_p + acu_aporte_e).to_s]]
            table data, header: true, cell_style: { size: 8 }
            start_new_page
        end
    end
end
