class Usuario < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    belongs_to :rol
    devise :database_authenticatable,
           :recoverable, :rememberable, :trackable, :validatable
    def Admininistrador?
        rol.id == 1
    end

    def Coordinador?
        rol.id== 2
    end
    def Regular?
        rol.id == 3
    end
end
