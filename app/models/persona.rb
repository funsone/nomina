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
  attr_accessor :asignaciones,:deducciones, :total,:total_asignaciones,:total_deducciones
  def calculo
    @MONTO= self.cargo.sueldos.last.monto
    self.asignaciones = []
    self.deducciones=[]
    self.total_asignaciones=0
    self.total_deducciones=0

    a=self.cargo.tipo.conceptos.where(tipo_de_concepto: 0)
    ap=self.registrosconceptos.joins(:conceptopersonal).where('"conceptospersonales"."tipo_de_concepto"= 0')
    d=self.cargo.tipo.conceptos.where(tipo_de_concepto: 1)
    dp=self.registrosconceptos.joins(:conceptopersonal).where('"conceptospersonales"."tipo_de_concepto"= 1')

    i=0

    a.each do |j|
      if j.modalidad_de_pago==$quincena or j.modalidad_de_pago==2
        valor=eval(j.formula).to_d
        self.total_asignaciones+=valor
        self.asignaciones[i]=Hash["nombre", j.nombre, "valor", (valor - 0.0005).round(2).to_s+"  Bs."]
        i+=1
      end
    end

    ap.each do |j|
      aplicar=false
      case j.modalidad_de_pago
      when 0
        quincena=j.created_at.day<=15 ? 0:1
        if quincena==$quincena and $ahora.month==j.created_at.month
          aplicar=true
        end
      when 1
        quincena=j.created_at.day<=15 ? 0:1
        if quincena!=$quincena and ($ahora.month==j.created_at.month or $ahora.month==j.created_at.month+1.month)

          aplicar=true
        end

      when 2..4
        if j.modalidad_de_pago==$quincena+2 or j.modalidad_de_pago==4
          aplicar=true
        end

      end
      if aplicar==true
        valor=eval(j.formula).to_d
        self.total_asignaciones+=valor
        self.asignaciones[i]=Hash["nombre", j.conceptopersonal.nombre, "valor", (valor - 0.0005).round(2).to_s+"  Bs."+j.modalidad_de_pago.to_s]
        i+=1
      end
    end
i=0

    d.each do |j|
      if j.modalidad_de_pago==$quincena or j.modalidad_de_pago==2
        valor=eval(j.formula).to_d
        self.total_deducciones+=valor
        self.deducciones[i]=Hash["nombre", j.nombre, "valor", (valor - 0.0005).round(2).to_s+"  Bs."]
        i+=1
      end
    end

    dp.each do |j|
      aplicar=false
      case j.modalidad_de_pago
      when 0
        quincena=j.created_at.day<=15 ? 0:1
        if quincena==$quincena and $ahora.month==j.created_at.month
          aplicar=true
        end
      when 1
        quincena=j.created_at.day<=15 ? 0:1
        if quincena!=$quincena and ($ahora.month==j.created_at.month or $ahora.month==j.created_at.month+1.month)

          aplicar=true
        end

      when 2..4
        if j.modalidad_de_pago==$quincena+2 or j.modalidad_de_pago==4
          aplicar=true
        end

      end
      if aplicar==true
        valor=eval(j.formula).to_d
        self.total_deducciones+=valor
        self.deducciones[i]=Hash["nombre", j.conceptopersonal.nombre, "valor", (valor - 0.0005).round(2).to_s+"  Bs."+j.modalidad_de_pago.to_s]
        i+=1
      end
    end


    tipo_de_contrato=self.contrato.tipo_de_contrato
    if tipo_de_contrato==2
      self.deducciones[i]=Hash["nombre", "COMISION DE SERVICIO", "valor", (self.contrato.sueldo_externo - 0.0005).round(2).to_s+"  Bs."]
      self.total_deducciones+=self.contrato.sueldo_externo
    end
    self.total=self.total_asignaciones-self.total_deducciones
    if tipo_de_contrato==2 and self.total<0
      self.total=0;
    end
  end

end
