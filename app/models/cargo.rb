class Cargo < ActiveRecord::Base
  resourcify
  belongs_to :departamento
  has_one :persona,  dependent: :destroy
  belongs_to :tipo
  has_many :sueldos ,  dependent: :destroy
  accepts_nested_attributes_for :sueldos
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  validates :departamento_id, presence: true
  validates :tipo_id, presence: true
  self.per_page = 10
  before_update :actualizar

  def actualizar
    nuevo = false
    if $quincena == 0
      nuevo = Sueldo.where(cargo_id: id).where(created_at: Time.now.beginning_of_month..(Time.now.beginning_of_month + 14.days)).empty?
    else
      nuevo = Sueldo.where(cargo_id: id).where(created_at: (Time.now.beginning_of_month + 15.days)..Time.now.end_of_month).empty?
    end
    if nuevo
      viejo = Sueldo.where(cargo_id: id).where(activo: true).last
      nmonto = sueldos.last.monto
      nsueldo_integral = sueldos.last.sueldo_integral
      sueldos.last.activo = false
      sueldos.last.monto = viejo.monto
      sueldos.last.sueldo_integral = viejo.sueldo_integral
      crear = sueldos.new
      crear.monto = nmonto
      crear.sueldo_integral = nsueldo_integral
    end
  end
  def self.search(search,dep)
  search=search.downcase
  if dep=="" and search==""
    order(:nombre)
  elsif dep and dep!="" and search==""
    where('departamento_id = CAST(? AS INTEGER)',dep)
  elsif dep and dep!=""

where('(LOWER(nombre) LIKE ? ) AND departamento_id = CAST(? AS INTEGER)', "%#{search}%",dep)
  elsif search and search!=""

  where('LOWER(nombre) LIKE ? ', "%#{search}%")
  end
  end
end
