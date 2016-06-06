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
def link
return 'id #<a href="' + departamento_path(id) + '"> ' + id.to_s + '</a>'
end
  def logc
    log("#{link}",2, 0)
  end
  def logu
    log("#{link}",2, 1)
  end
  def logd
    log("#{id}",2, 2)
  end
end
