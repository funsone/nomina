class Dependencia < ActiveRecord::Base
  resourcify
    validates :nombre, uniqueness: { case_sensitive: false }, presence: true
    has_many :departamentos, dependent: :destroy
    after_create :logc
    after_destroy :logd
    after_update :logu

  include Rails.application.routes.url_helpers
  def link
  return 'id #<a href="' + dependencia_path(id) + '"> ' + id.to_s + '</a>'
  end
    def logc
      log("#{link}",3, 0)
    end
    def logu
      log("#{link}",3, 1)
    end
    def logd
      log("#{id}",3, 2)
    end
end
