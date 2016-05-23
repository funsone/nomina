class Cargo < ActiveRecord::Base
  resourcify
  belongs_to :departamento
  has_one :persona,  :dependent => :destroy
  belongs_to :tipo
  has_many :sueldos ,  :dependent => :destroy
  accepts_nested_attributes_for :sueldos
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  validates :departamento_id, presence: true
    validates :tipo_id, presence: true
  self.per_page = 10
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
