class Persona < ActiveRecord::Base
  belongs_to :cargo
  has_one :contrato,  :dependent => :destroy
  accepts_nested_attributes_for :contrato
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
 validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
end
