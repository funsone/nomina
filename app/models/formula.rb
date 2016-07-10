class MyValidator < ActiveModel::Validator
  def validate(record)
    calculator = Dentaku::Calculator.new
    begin

      if calculator.evaluate(record.empleado, sueldo: 1, sueldo_integral: 1, lunes_del_mes: 1).nil?
        throw Exception
      end

    rescue Exception => e
      record.errors[:empleado] << 'Es invalida'
    end

    calculator = Dentaku::Calculator.new
    begin
      if calculator.evaluate(record.patrono, sueldo: 1, sueldo_integral: 1, lunes_del_mes: 1).nil?
        throw Exception
      end
    rescue Exception => e
      record.errors[:patrono] << 'Es invalida'
    end
  end
end

class Formula < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :concepto
  validates_with MyValidator
  validates :empleado, :patrono, presence: true
end
