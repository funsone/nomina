class Persona < ActiveRecord::Base
  belongs_to :cargo
  has_one :contrato, dependent: :destroy
  accepts_nested_attributes_for :contrato
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  paginates_per 20
  validates :tipo_de_cedula, :cedula, :nombres, :apellidos, :correo, :fecha_de_nacimiento, :sexo, :status, :cargo, :cuenta, :direccion, presence: true
  validates :correo, uniqueness: { case_sensitive: false, message: 'El correo ingresado ya existe.' }, format: { with: VALID_EMAIL_REGEX, message: 'El formato del correo es invalido' }
  validates :cedula, uniqueness: { case_sensitive: false, message: 'ya esta registrada.' }, numericality: { only_integer: true }
  validates :nombres, :apellidos, length: { in: 0..50 }
  validates :telefono_fijo, :telefono_movil, length: { is: 11 }, numericality: { only_integer: true }, allow_blank: true
end
