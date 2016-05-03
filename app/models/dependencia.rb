class Dependencia < ActiveRecord::Base
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
    has_many :departamentos, :dependent => :destroy
end
