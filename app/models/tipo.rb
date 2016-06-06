class Tipo < ActiveRecord::Base
  resourcify
  has_many :cargos,  dependent: :destroy
  has_and_belongs_to_many :conceptos
    validates :nombre, uniqueness: true, presence: true
    after_create :logc
    after_destroy :logd
    after_update :logu

  include Rails.application.routes.url_helpers
  def link
  return 'id #<a href="' + tipo_path(id) + '"> ' + id.to_s + '</a>'
  end
    def logc
      log("#{link}",5, 0)
    end
    def logu
      log("#{link}",5, 1)
    end
    def logd
      log("#{id}",5, 2)
    end
end
