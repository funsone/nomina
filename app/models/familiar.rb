class Familiar < ActiveRecord::Base
  resourcify
  belongs_to :persona
  validates :nombres, :apellidos, :fecha_de_nacimiento, :sexo, :direccion, presence: true
  validates :cedula, uniqueness: { case_sensitive: false, message: 'ya esta registrada.' }, numericality: { only_integer: true }, allow_blank: true
  validates :nombres, :apellidos, length: { in: 0..50 }
  validates :fecha_de_nacimiento, date: { before: proc { Time.now }, message: 'es invalida. El Familiar no ha nacido.' }
  validates :cedula, :direccion,:parentesco, presence: true
end
