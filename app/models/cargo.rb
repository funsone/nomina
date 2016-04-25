class Cargo < ActiveRecord::Base
  belongs_to :departamento
  has_one :persona,  :dependent => :destroy
  belongs_to :tipo
  has_many :sueldos ,  :dependent => :destroy
  accepts_nested_attributes_for :sueldos
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  self.per_page = 1
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
