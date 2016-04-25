class Dependencia < ActiveRecord::Base
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
end
