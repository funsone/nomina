class Tipo < ActiveRecord::Base
  has_many :cargos,  :dependent => :destroy
  has_and_belongs_to_many :conceptos
    paginates_per 10
    validates :nombre, uniqueness: true, presence: true
end
