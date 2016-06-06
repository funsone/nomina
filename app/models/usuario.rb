class Usuario < ActiveRecord::Base
  rolify
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable

    devise :database_authenticatable, :rememberable, :trackable, :validatable
    def self.current
      Thread.current[:usuario]
    end
    def self.current=(usuario)
      Thread.current[:usuario] = usuario.id
    end
end
