class Cargo < ActiveRecord::Base
  resourcify
  belongs_to :departamento
  has_one :persona,  dependent: :destroy
  belongs_to :tipo
  has_many :sueldos ,  dependent: :destroy
  has_many :historiales ,  dependent: :destroy
  accepts_nested_attributes_for :sueldos
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  validates :departamento_id, presence: true
  validates :tipo_id, presence: true
  self.per_page = 10
  before_update :actualizar
  after_create :logc
  after_destroy :logd
  after_update :logu
    attr_accessor :p,:d
include Rails.application.routes.url_helpers
def persona_ahora
  personas= Historial.where("cargo_id = ? ", id)

  if personas.length>0
    personas.each do |c|
      min=0
      c.fecha_fin=$ahora if c.fecha_fin.nil?
      if c.fecha_inicio.day<=15
        min=Date.civil(c.fecha_inicio.year,c.fecha_inicio.mon, 1)
      else
        min=Date.civil(c.fecha_inicio.year,c.fecha_inicio.mon, 16)
      end
      max=0
      if c.fecha_fin.day<=15
        max=Date.civil(c.fecha_fin.year,c.fecha_fin.mon, 15)
      else
        max=Date.civil(c.fecha_fin.year,c.fecha_fin.mon, -1)
      end

      if (min..max).cover?($ahora)
          self.p=c.persona
          self.d=false
      else
        self.d=true

      end
    end
  end
end

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
