class Familiar < ActiveRecord::Base
  resourcify
  belongs_to :persona
  validates :nombres, :apellidos, :fecha_de_nacimiento, :sexo, :direccion,:cedula, :direccion,:parentesco, presence: true
  validates :cedula, uniqueness: { message: 'Ya se encuentra registrada' }, numericality: { only_integer: true }
  validates :nombres, :apellidos, length: { in: 0..50 }
  validates :fecha_de_nacimiento, date: { before: proc { Time.now }, message: 'Es inválida, el familiar no ha nacido' }
  attr_readonly :cedula, :tipo_de_cedula

  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    if mock.valid?
      true
    else
      !mock.errors.has_key?(attr)
    end
  end

end
