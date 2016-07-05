class Requisito < ActiveRecord::Base
  resourcify
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
    has_and_belongs_to_many :personas
end
