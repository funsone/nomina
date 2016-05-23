class Departamento < ActiveRecord::Base
  resourcify
  belongs_to :dependencia
  has_many :cargos ,  :dependent => :destroy
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  validates :dependencia_id, presence: true
end
