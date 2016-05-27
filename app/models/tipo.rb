class Tipo < ActiveRecord::Base
  resourcify
  has_many :cargos,  dependent: :destroy
  has_and_belongs_to_many :conceptos
    validates :nombre, uniqueness: true, presence: true
end
