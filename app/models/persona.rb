class Persona < ActiveRecord::Base
  include AASM
  aasm column: "status" do 

    state :activo , initial:true
    state :suspendido
    state :retirado
    event :retirar do
      transitions from: :activo, to: :retirado
      after do
        self.cargo.disponible=true;
        self.cargo.save
      end
    end
    event :reingresar do
      transitions from: :retirado, to: :activo
      after do
        self.cargo.disponible=false;
        self.cargo.save
      end
    end

    event :suspender do
      transitions from: :activo, to: :suspendido
    end
  end
  belongs_to :cargo
  has_one :contrato, dependent: :destroy
  has_many :familiares, dependent: :destroy
  has_many :registrosconceptos
  accepts_nested_attributes_for :contrato, :familiares,:registrosconceptos, reject_if: :all_blank, allow_destroy: true
  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/images/:style/missing.png'
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  paginates_per 1
  attr_readonly :tipo_de_cedula, :cedula
  validates :tipo_de_cedula, :cedula, :nombres, :apellidos, :correo, :fecha_de_nacimiento, :sexo, :cargo, :cuenta, :direccion, presence: true
  validates :correo, uniqueness: { case_sensitive: false, message: 'El correo ingresado ya existe.' }, format: { with: VALID_EMAIL_REGEX, message: 'El formato del correo es invalido' }
  validates :cedula, uniqueness: { case_sensitive: false, message: 'ya esta registrada.' }, numericality: { only_integer: true }
  validates :nombres, :apellidos, length: { in: 0..50 }
  validates :cuenta, numericality: { only_integer: true }
  validates :telefono_fijo, :telefono_movil, length: { is: 11 }, allow_blank: true, numericality: { only_integer: true }
  validates :cuenta, length: { is: 20 }
  validates :fecha_de_nacimiento, date: { before: proc { Time.now - 18.year }, message: 'es invalida. La persona debe ser mayor de edad.' }

end
