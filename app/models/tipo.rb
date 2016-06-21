class Tipo < ActiveRecord::Base
  resourcify
  has_many :cargos,  dependent: :destroy
  has_and_belongs_to_many :conceptos
    validates :nombre, uniqueness: true, presence: true
    after_create :logc
    after_destroy :logd
    after_update :logu

  include Rails.application.routes.url_helpers
  def logc
    log(id.to_s,changes.to_json.to_s, 5, 0)
  end

  def logu
    log(id.to_s, changes.to_json.to_s, 5, 1)
  end

  def logd
    log(id.to_s,"{}".to_json, 5, 2)
  end
end
