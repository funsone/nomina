class Persona < ActiveRecord::Base
  resourcify
  after_create :logc
  after_destroy :logd
  after_update :logu


after_save :cambiar_cargo

  def generar_historial

    h=Historial.new
    h.cargo_id=cargo.id
    h.persona_id=id
    h.save
  end
  def cambiar_cargo
  if Persona.where(id: id).length>0

    if cargo_id_changed? and cargo_id_was!= nil

generar_historial
    end
  end
  end

  include Rails.application.routes.url_helpers


  def logc
    generar_historial
    if changes.include?(:nombres) || changes.include?(:apellidos) || changes.include?(:cedula) || changes.include?(:tipo_de_cedula) || changes.include?(:fecha_de_nacimiento) || changes.include?(:telefono_fijo) || changes.include?(:telefono_movil) || changes.include?(:correo) || changes.include?(:cuenta) || changes.include?(:fotografia) || changes.include?(:sexo)|| changes.include?(:direccion) || changes.include?(:cargo_id) || changes.include?(:IVSS) || changes.include?(:TSS) || changes.include?(:FAOV) || changes.include?(:caja_de_ahorro)
    log(id.to_s,changes.to_json.to_s, 4, 0)
    end
  end

  def logu
    if changes.include?(:nombres) || changes.include?(:apellidos) || changes.include?(:cedula) || changes.include?(:tipo_de_cedula) || changes.include?(:fecha_de_nacimiento) || changes.include?(:telefono_fijo) || changes.include?(:telefono_movil) || changes.include?(:correo) || changes.include?(:cuenta) || changes.include?(:fotografia) || changes.include?(:sexo)|| changes.include?(:direccion) || changes.include?(:cargo_id) || changes.include?(:IVSS) || changes.include?(:TSS) || changes.include?(:FAOV) || changes.include?(:caja_de_ahorro)
    log(id.to_s, changes.to_json.to_s, 4, 1)
    end
  end

  def logd
    log(id.to_s,"{}".to_json, 4, 2)
  end

  self.per_page = 10
  attr_readonly :cedula, :tipo_de_cedula
  include AASM
  aasm column: 'status' do
    state :activo, initial: true
    state :suspendido
    state :retirado
    event :retirar do
    transitions from: :activo, to: :retirado
      after do
        h_viejo = Historial.where('persona_id = ? ', id).last

        self.contrato.fecha_fin= $ahora
        self.save
        unless h_viejo.nil?
          h_viejo.cargo.disponible = true
          h_viejo.cargo.save
          if (h_viejo.fecha_inicio.day <= 15 && Time.now.day > 15 && Time.now.month == h_viejo.fecha_inicio.month) || (Time.now.month != h_viejo.fecha_inicio.month)
            max = 0
            if Time.now.day <= 15
              max = if Time.now.mon == 1
                      Date.civil(Time.now.year - 1 - year, 12, -1)
                    else
                      Date.civil(Time.now.year, Time.now.month - 1, -1)
                    end

            else

              max = Date.civil(Time.now.year, Time.now.mon, 15)

            end

            h_viejo.fecha_fin = max
            h_viejo.save

          else
            h_viejo.destroy
            h_viejo.save
          end
        end
      end
    end
    event :reingresar do
      transitions from: :retirado, to: :activo
      before do
          self.contrato.fecha_inicio = $ahora
          self.contrato.fecha_fin= ""
          self.save
        if cargo.disponible = true
          cargo.disponible= false
        end
      end
    end
    event :suspender do
      transitions from: :activo, to: :suspendido
    end
    event :reactivar do
      transitions from: :suspendido, to: :activo
    end
  end
  belongs_to :cargo
    has_and_belongs_to_many :requisitos
  has_one :contrato, dependent: :destroy
  has_many :familiares, dependent: :destroy
  has_many :registrosconceptos, dependent: :destroy
  has_many :historiales ,  dependent: :destroy
  accepts_nested_attributes_for :contrato, :familiares, :registrosconceptos, allow_destroy: true


  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/assets/predeterminado.png'
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  attr_readonly :tipo_de_cedula, :cedula
  validates :tipo_de_cedula, :cedula, :nombres, :apellidos, :correo, :fecha_de_nacimiento, :sexo, :cuenta, :direccion, :cargo_id, presence: true
  validates :correo, uniqueness: { case_sensitive: false, message: 'El correo ingresado ya existe' }, format: { with: VALID_EMAIL_REGEX, message: 'El formato del correo es inválido' }
  validates :cedula, uniqueness: { case_sensitive: false, message: 'Ya se encuentra registrada' }, numericality: { only_integer: true }
  validates :nombres, :apellidos, length: { in: 0..50 }
  validates :cuenta, numericality: { only_integer: true }
  validates :telefono_fijo, :telefono_movil, length: { is: 11 }, allow_blank: true, numericality: { only_integer: true }
  validates :cuenta, length: { is: 20 }
  validates :fecha_de_nacimiento, date: { before: proc { Time.now - 18.year }, message: 'es inválida, la persona debe ser mayor de edad' }

  attr_accessor :asignaciones, :deducciones, :total, :total_asignaciones, :total_deducciones, :valido
  def self.search(search, dep, tipo)
    search = search.downcase
    # sin filtro
    if dep == '' && search == '' && tipo == ''
      order(:id)
      # solo departaent
    elsif dep && dep != '' && search == '' && tipo == ''
      joins(:cargo).where('"cargos"."departamento_id" = CAST(? AS INTEGER)', dep).order(:id)
      # solo tipo
    elsif tipo && tipo != '' && search == '' && dep == ''
      joins(:cargo).where('"cargos"."tipo_id" = CAST(? AS INTEGER)', tipo).order(:id)
      # tipo y depatamento
    elsif tipo && tipo != '' && search == '' && dep && dep != ''
      joins(:cargo).where('"cargos"."tipo_id" = CAST(? AS INTEGER) AND "cargos"."departamento_id" = CAST(? AS INTEGER) ', tipo, dep).order(:id)
      # departamento y busqueda
    elsif dep && dep != '' && search && search != '' && tipo == ''
      joins(:cargo).where('(cedula LIKE ? OR LOWER(nombres) LIKE ? OR LOWER(apellidos) LIKE ? OR CONCAT(LOWER(nombres), \' \', LOWER(apellidos)) LIKE ?) AND "cargos"."departamento_id" = CAST(? AS INTEGER)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", dep).order(:id)
      # tipo y busqueda
    elsif tipo && tipo != '' && search && search != '' && dep == ''
      joins(:cargo).where('(cedula LIKE ? OR LOWER(nombres) LIKE ? OR LOWER(apellidos) LIKE ? OR CONCAT(LOWER(nombres), \' \', LOWER(apellidos)) LIKE ?) AND "cargos"."tipo_id" = CAST(? AS INTEGER)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", tipo).order(:id)
      # tipo departamento y busqueda
    elsif tipo && tipo != '' && dep && dep != '' && search && search != ''
      joins(:cargo).where('(cedula LIKE ? OR LOWER(nombres) LIKE ? OR LOWER(apellidos) LIKE ? OR CONCAT(LOWER(nombres), \' \', LOWER(apellidos)) LIKE ?) AND "cargos"."departamento_id" = CAST(? AS INTEGER) AND "cargos"."tipo_id" = CAST(? AS INTEGER)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", dep, tipo).order(:id)
    # solo busqueda
    elsif search && search != ''
      where('cedula LIKE ? OR LOWER(nombres) LIKE ? OR LOWER(apellidos) LIKE ? OR CONCAT(LOWER(nombres), \' \', LOWER(apellidos)) LIKE ? ', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%").order(:id)
    end
  end

  def calculo(extras)
    self.asignaciones = []
    self.deducciones = []
    self.total_asignaciones = 0
    self.total_deducciones = 0
    self.total = 0
    self.valido = true
    #busca cargo perteneciente a la persona en una fecha
    cargos= Historial.where("persona_id = ? ", id)

    if cargos.length!=1 and cargos.length>0
      cargos.each do |c|
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

        self.cargo=c.cargo if(min..max).cover?($ahora)
      end
    end
    lunes = [1]
    inicio_mes = Date.civil($ahora.year, $ahora.month, 1)
    fin_mes = Date.civil($ahora.year, $ahora.month, -1)
    fecha = ($quincena == 0) ? Date.civil($ahora.year, $ahora.month, 15) : fin_mes
    sueldos = cargo.sueldos.where('created_at <= ? ', fecha+23.hours+59.minutes+59.seconds)
    if sueldos.empty? ==true
      self.valido = false
      throw Exception
      return 0
    end
    r = (inicio_mes..fin_mes).to_a.select { |k| lunes.include?(k.wday) }

    @SUELDO = sueldos.last.monto
    @NORMAL = sueldos.last.normal
    @SUELDO_INTEGRAL = sueldos.last.sueldo_integral
    @LUNES_DEL_MES = r.length
    @CONDICIONES = [self.FAOV,self.IVSS, self.TSS, caja_de_ahorro, extras]
    asig = [cargo.tipo.conceptos.where(tipo_de_concepto: 0), registrosconceptos.joins(:conceptopersonal).where('"conceptospersonales"."tipo_de_concepto"= 0')]

    dedu = [cargo.tipo.conceptos.where(tipo_de_concepto: 1), registrosconceptos.joins(:conceptopersonal).where('"conceptospersonales"."tipo_de_concepto"= 1')]

    i = 0
    asig.each do |a|
      a.each do |j|
        next unless j.puede_aplicar @CONDICIONES
        j.calcular fecha, @SUELDO, @SUELDO_INTEGRAL, @LUNES_DEL_MES, @NORMAL
        next unless j.valido
        self.total_asignaciones += j.valor
        asignaciones[i] = j.para_mostrar
        i += 1
      end
    end
    i = 0
    dedu.each do |d|
      d.each do |j|
        next unless j.puede_aplicar @CONDICIONES
        j.calcular fecha, @SUELDO, @SUELDO_INTEGRAL, @LUNES_DEL_MES, @NORMAL
        next unless j.valido
        self.total_deducciones += j.valor
        deducciones[i] = j.para_mostrar
        i += 1
      end
    end
    tipo_de_contrato = contrato.tipo_de_contrato
    if tipo_de_contrato == 2
      deducciones[i] = Hash['nombre', 'COMISION DE SERVICIO', 'valor', truncar(contrato.sueldo_externo).to_s]
      self.total_deducciones += contrato.sueldo_externo
    end
    self.total_deducciones = truncar(self.total_deducciones)
    self.total_asignaciones = truncar(self.total_asignaciones)
    self.total = truncar(self.total_asignaciones - self.total_deducciones)
    self.total = 0 if tipo_de_contrato == 2 && total < 0
  end
end
