class MyValidator < ActiveModel::Validator
  def validate(record)
calculator = Dentaku::Calculator.new
    begin

      if calculator.evaluate(record.empleado, sueldo:1,sueldo_integral:1, lunes_del_mes:1,sueldo_normal: 1).nil?
throw Exception
      end

    rescue Exception => e
  record.errors[:empleado] << "Es inválida"
    end

    calculator = Dentaku::Calculator.new
    begin
  if calculator.evaluate(record.patrono, sueldo:1,sueldo_integral:1, lunes_del_mes:1,sueldo_normal: 1).nil?
throw Exception
  end
    rescue Exception => e
  record.errors[:patrono] << "Es inválida"
    end

  end

end
class Formulapersonal < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :registroconcepto
  validates_with MyValidator
  validates :empleado, :patrono, presence: true
  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    if mock.valid?
      true
    else
      !mock.errors.has_key?(attr)
    end
  end
end
