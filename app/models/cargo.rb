class Cargo < ActiveRecord::Base
  resourcify
  belongs_to :departamento
  has_one :persona, dependent: :destroy
  belongs_to :tipo
  has_many :sueldos, dependent: :destroy
  has_many :historiales, dependent: :destroy
  accepts_nested_attributes_for :sueldos
  validates :nombre, presence: true
  validates :departamento_id, presence: true
  validates :tipo_id, presence: true
  attr_readonly :departamento_id, :tipo_id
  self.per_page = 10
  before_update :actualizar
  after_create :logc
  after_destroy :logd
  after_update :logu
  attr_accessor :p, :d
  include Rails.application.routes.url_helpers
  def persona_ahora
    personas = Historial.where('cargo_id = ? ', id)

    unless personas.empty?
      personas.each do |c|
        min = 0
        c.fecha_fin = $ahora if c.fecha_fin.nil?
        min = if c.fecha_inicio.day <= 15
                Date.civil(c.fecha_inicio.year, c.fecha_inicio.mon, 1)
              else
                Date.civil(c.fecha_inicio.year, c.fecha_inicio.mon, 16)
              end
        max = 0
        max = if c.fecha_fin.day <= 15
                Date.civil(c.fecha_fin.year, c.fecha_fin.mon, 15)
              else
                Date.civil(c.fecha_fin.year, c.fecha_fin.mon, -1)
              end
        if (min..max).cover?($ahora)
          self.p = c.persona
          self.d = false
        else
          self.d = true
        end
      end
    end
  end

  def logc
    if changes.include?(:nombre) || changes.include?(:tipo_id) || changes.include?(:departamento_id)
      log(id.to_s, changes.to_json.to_s, 6, 0)
    end
  end

  def logu
    if changes.include?(:nombre) || changes.include?(:tipo_id) || changes.include?(:departamento_id)
      log(id.to_s, changes.to_json.to_s, 6, 1)
    end
  end

  def logd
    log(id.to_s, '{}'.to_json, 6, 2)
  end

  def truncar_sueldo
    sueldos.last.monto = truncar(sueldos.last.monto)
    sueldos.last.sueldo_integral = truncar(sueldos.last.sueldo_integral)
    sueldos.last.normal = truncar(sueldos.last.normal)

  end

  def actualizar
    return unless sueldos.last.monto_changed? || sueldos.last.sueldo_integral_changed?|| sueldos.last.normal_changed?

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
      nnormal = sueldos.last.normal
      sueldos.last.activo = false
      sueldos.last.monto = viejo.monto
      sueldos.last.sueldo_integral = viejo.sueldo_integral
      sueldos.last.normal = viejo.normal
      crear = sueldos.new
      crear.monto = truncar(nmonto)
      crear.sueldo_integral = truncar(nsueldo_integral)
      crear.normal = truncar(nnormal)
    else
      truncar_sueldo
    end
  end

  def self.search(search, dep)
    search = search.downcase
    if dep == '' && search == ''
      order(:nombre)
    elsif dep && dep != '' && search == ''
      where('departamento_id = CAST(? AS INTEGER)', dep)
    elsif dep && dep != ''
      where('(LOWER(nombre) LIKE ? ) AND departamento_id = CAST(? AS INTEGER)', "%#{search}%", dep)
    elsif search && search != ''
      where('LOWER(nombre) LIKE ? ', "%#{search}%")
    end
  end
end
