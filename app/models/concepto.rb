class Concepto < ActiveRecord::Base
has_and_belongs_to_many :tipos
end
