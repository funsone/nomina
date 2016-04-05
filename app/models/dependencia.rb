class Dependencia < ActiveRecord::Base
    paginates_per 10
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
end
