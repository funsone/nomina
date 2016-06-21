class Departamento < ActiveRecord::Base
  resourcify
  belongs_to :dependencia
  has_many :cargos ,  dependent: :destroy
  validates :nombre, uniqueness: { case_sensitive: false }, presence: true
  validates :dependencia_id, presence: true
  after_create :logc
  after_destroy :logd
  after_update :logu

include Rails.application.routes.url_helpers
def logc
  log(id.to_s,changes.to_json.to_s, 2, 0)
end

def logu
  log(id.to_s, changes.to_json.to_s, 2, 1)
end

def logd
  log(id.to_s,"{}".to_json, 2, 2)
end
end
