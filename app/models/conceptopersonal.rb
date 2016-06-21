class Conceptopersonal < ActiveRecord::Base
	has_many :registrosconceptos, dependent: :destroy
	validates :nombre, uniqueness: true, presence: true
	validates :tipo_de_concepto, presence: true
	after_create :logc
	after_destroy :logd
	after_update :logu

	include Rails.application.routes.url_helpers
	def logc
    log(id.to_s,changes.to_json.to_s, 1, 0)
  end

  def logu
    log(id.to_s, changes.to_json.to_s, 1, 1)
  end

  def logd
    log(id.to_s,"{}".to_json, 1, 2)
  end
end
