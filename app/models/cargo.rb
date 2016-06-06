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
  before_create :truncar_sueldo
  after_create :logc
  after_destroy :logd
  after_update :logu

include Rails.application.routes.url_helpers
def link
return 'id #<a href="' + cargo_path(id) + '"> ' + id.to_s + '</a>'
end
  def logc
    log("#{link}",6, 0)
  end
  def logu
    log("#{link}",6, 1)
  end
  def logd
    log("#{id}",6, 2)
  end
  def truncar_sueldo
    sueldos.last.monto=truncar(sueldos.last.monto)
    sueldos.last.sueldo_integral=truncar(sueldos.last.sueldo_integral)
  end


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
      crear.monto = truncar(nmonto)
      crear.sueldo_integral = truncar(nsueldo_integral)
    else
      truncar_sueldo
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
