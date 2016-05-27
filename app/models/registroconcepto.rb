class Registroconcepto < ActiveRecord::Base
  has_many :formulaspersonales, dependent: :destroy
  accepts_nested_attributes_for :formulaspersonales
  belongs_to :persona
  belongs_to :conceptopersonal
  validates :conceptopersonal_id, presence: true
  validates :modalidad_de_pago, presence: true
  before_update :actualizar

  attr_accessor :valor, :valor_patrono, :para_mostrar, :valido
  
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
      if condiciones[4]
        quincena = created_at.day <= 15 ? 0 : 1
        if quincena == $quincena && $ahora.month == created_at.month
          aplicar = true
        end
      end
    when 6
      if condiciones[4]
        quincena = created_at.day <= 15 ? 0 : 1
        if quincena != $quincena && (created_at.month == $ahora.month || created_at.month == $ahora.month - 1)

          aplicar = true

        end
      end
    end
    aplicar
  end

  def calcular(fecha, sueldo, sueldo_integral, lunes_del_mes)
    f = formulaspersonales.where('created_at < ?', fecha)
    self.valido = false
    unless f.empty?
      calc = Dentaku::Calculator.new
      self.valido = true
      f = f.last
      self.valor = calc.evaluate(f.empleado, sueldo: sueldo, sueldo_integral: sueldo_integral, lunes_del_mes: lunes_del_mes).to_d
      self.valor_patrono = calc.evaluate(f.patrono, sueldo: sueldo, sueldo_integral: sueldo_integral, lunes_del_mes: lunes_del_mes).to_d
      extra = (modalidad_de_pago == 6 || modalidad_de_pago == 5) ? true : false
      self.para_mostrar = Hash['nombre', conceptopersonal.nombre, 'valor', truncar(valor).to_s, 'valor_patrono', truncar(valor_patrono).to_s, 'clase_de_concepto', 1, 'extra', extra]
    end
  end

  protected

  def actualizar
    nuevo = false
    if $quincena == 0
      nuevo = Formulapersonal.where(registroconcepto_id: id).where(created_at: Time.now.beginning_of_month..(Time.now.beginning_of_month + 14.days)).empty?
    else
      nuevo = Formulapersonal.where(registroconcepto_id: id).where(created_at: (Time.now.beginning_of_month + 15.days)..Time.now.end_of_month).empty?
    end
    if nuevo
      viejo = Formulapersonal.where(registroconcepto_id: id).where(activo: true).last
      npatrono = formulaspersonales.last.patrono
      nempleado = formulaspersonales.last.empleado
      formulaspersonales.last.activo = false
      formulaspersonales.last.patrono = viejo.patrono
      formulaspersonales.last.empleado = viejo.empleado
      crear = formulaspersonales.new
      crear.empleado = nempleado
      crear.patrono = npatrono
    end
  end
end
