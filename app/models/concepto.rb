class Concepto < ActiveRecord::Base
    resourcify
    has_many :formulas, dependent: :destroy
    accepts_nested_attributes_for :formulas
    has_and_belongs_to_many :tipos
    validates :nombre, uniqueness: true, presence: true
    validates :modalidad_de_pago, presence: true
    attr_accessor :valor, :valor_patrono, :para_mostrar, :valido
    def truncar(n)
        ('%0.2f' % n).to_f
    end

    def puede_aplicar(condiciones)
        aplicar = false
        case modalidad_de_pago
        when 0
            quincena = created_at.day <= 15 ? 0 : 1
            if quincena == $quincena && $ahora.month == created_at.month
                aplicar = true
            end
        when 1
            quincena = created_at.day <= 15 ? 0 : 1
            if quincena != $quincena && (created_at.month == $ahora.month || created_at.month == $ahora.month - 1)

                aplicar = true

            end
        when 2..4
            if modalidad_de_pago == $quincena + 2 || modalidad_de_pago == 4
                aplicar = true
            end
        when 5
            if condiciones[4] == true
                quincena = created_at.day <= 15 ? 0 : 1
                if quincena == $quincena && $ahora.month == created_at.month
                    aplicar = true
                end
            else

                return false
          end
        when 6
            if condiciones[4] == true
                quincena = created_at.day <= 15 ? 0 : 1
                if quincena != $quincena && (created_at.month == $ahora.month || created_at.month == $ahora.month - 1)

                    aplicar = true

                end
            else

                return false
            end

          end
        aplicarc = false
        case condicion

        when 0
            aplicarc = true
        when 1
            aplicarc = condiciones[0] ? true : false
        when 2
            aplicarc = condiciones[1] ? true : false
        when 3
            aplicarc = condiciones[2] ? true : false
        when 4
            aplicarc = condiciones[3] ? true : false
        end
        aplicar && aplicarc
    end

    def calcular(fecha, sueldo, sueldo_integral, lunes_del_mes)
        f = formulas.where('created_at < ?', fecha)
        self.valido = false
        unless f.empty?
            calc = Dentaku::Calculator.new
            self.valido = true
            f = f.last
            self.valor = calc.evaluate(f.empleado, sueldo: sueldo, sueldo_integral: sueldo_integral, lunes_del_mes: lunes_del_mes).to_d
            self.valor_patrono = calc.evaluate(f.patrono, sueldo: sueldo, sueldo_integral: sueldo_integral, lunes_del_mes: lunes_del_mes).to_d
            self.para_mostrar = Hash['nombre', nombre, 'valor', truncar(valor).to_s, 'valor_patrono', truncar(valor_patrono).to_s]
        end
    end
end
