class Dependencia < ActiveRecord::Base
  resourcify
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
    has_many :departamentos, dependent: :destroy
    after_create :logc
    after_destroy :logd
    after_update :logu

  include Rails.application.routes.url_helpers
  def logc
    log(id.to_s,changes.to_json.to_s, 3, 0)
  end

  def logu
    log(id.to_s, changes.to_json.to_s, 3, 1)
  end

  def logd
    log(id.to_s,"{}".to_json, 3, 2)
  end
end
