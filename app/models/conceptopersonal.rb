class Conceptopersonal < ActiveRecord::Base
	has_many :registrosconceptos, dependent: :destroy
	validates :nombre, uniqueness: true, presence: true
	validates :tipo_de_concepto, presence: true
	after_create :logc
	after_destroy :logd
	after_update :logu

	include Rails.application.routes.url_helpers
	def link
	return 'id #<a href="' + conceptopersonal_path(id) + '"> ' + id.to_s + '</a>'
	end
	def logc
		log("#{link}",1, 0)
	end
	def logu
		log("#{link}",1, 1)
	end
	def logd
		log("#{id}",1, 2)
	end
end
