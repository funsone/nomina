class Concepto < ActiveRecord::Base
  resourcify
  has_many :formulas, dependent: :destroy
  accepts_nested_attributes_for :formulas
  has_and_belongs_to_many :tipos
  validates :nombre, uniqueness: true, presence: true
  validates :modalidad_de_pago, :tipo_de_concepto, :condicion, presence: true
  attr_readonly :modalidad_de_pago, :tipo_de_concepto, :condicion, :nombre, :tipo_ids
  attr_accessor :valor, :valor_patrono, :para_mostrar, :valido
  before_update :actualizar
  after_create :logc
  after_destroy :logd
  after_update :logu
  before_create :poner_fecha_fin

  include Rails.application.routes.url_helpers
  def logc
    if changes.include?(:nombre) || changes.include?(:modalidad_de_pago) || changes.include?(:tipo_de_concepto) || changes.include?(:tipos_id) || changes.include?(:condicion)
    log(id.to_s, changes.to_json.to_s, 0, 0)
    end
  end
  def logu
    if changes.include?(:nombre) || changes.include?(:modalidad_de_pago) || changes.include?(:tipo_de_concepto) || changes.include?(:tipos_id) || changes.include?(:condicion)
    log(id.to_s, changes.to_json.to_s, 0, 1)
    end
  end
  def logd
    log(id.to_s, '{}'.to_json, 0, 2)
  end

  def poner_fecha_fin
    if modalidad_de_pago == 0 || modalidad_de_pago == 5
      self.fecha_fin = if Time.now.day <= 15
                          Date.civil(Time.now.year, Time.now.mon, 15)
                       else
                         Date.civil(Time.now.year, Time.now.mon, -1)
                       end
    elsif modalidad_de_pago == 1 || modalidad_de_pago == 6
      if Time.now.day <= 15
        self.fecha_fin = Date.civil(Time.now.year, Time.now.mon, -1)
      else
        if Time.now.mon == 12
          self.fecha_fin = Date.civil(Time.now.year + 1, 1, 15)

        else
          self.fecha_fin = Date.civil(Time.now.year, Time.now.mon + 1, 15)
        end

      end
    end
  end

  def eliminable
    quincena = created_at.day <= 15 ? 0 : 1
    ($quincena == quincena && Time.now.month == created_at.month) ? true : false
  end

  def desactivable
    case modalidad_de_pago
    when 0..1
      return false
    when 5..6
      return false
    when 2..4
      return true
    end
  end

  def desactivar
    max = 0
    if Time.now.day <= 15
      max = if Time.now.mon == 1
              Date.civil(Time.now.year - 1, 12, -1)
            else
              Date.civil(Time.now.year, Time.now.month - 1, -1)
            end

    else

      max = Date.civil(Time.now.year, Time.now.mon, 15)

    end
    update_column(:fecha_fin, max)
  end

  def actualizar
    nuevo = false
    if $quincena == 0
      nuevo = Formula.where(concepto_id: id).where(created_at: Time.now.beginning_of_month..(Time.now.beginning_of_month + 14.days)).empty?
    else
      nuevo = Formula.where(concepto_id: id).where(created_at: (Time.now.beginning_of_month + 15.days)..Time.now.end_of_month).empty?
    end
    if nuevo
      viejo = Formula.where(concepto_id: id).last
      npatrono = formulas.last.patrono
      nempleado = formulas.last.empleado
      formulas.last.activo = false
      formulas.last.patrono = viejo.patrono
      formulas.last.empleado = viejo.empleado
      crear = formulas.new
      crear.empleado = nempleado
      crear.patrono = npatrono
    end
  end

  def puede_aplicar(condiciones)
    if fecha_fin.nil? == false
      return false if $ahora >= fecha_fin
    end
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
      aplicarc = condiciones[0] == true ? true : false
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
      extra = (modalidad_de_pago == 6 || modalidad_de_pago == 5) ? true : false
      self.para_mostrar = Hash['nombre', nombre, 'valor', truncar(valor).to_s, 'valor_patrono', truncar(valor_patrono).to_s, 'clase_de_concepto', 0, 'extra', extra]
    end
  end
end
