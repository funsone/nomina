class Historial < ActiveRecord::Base
  belongs_to :persona
  belongs_to :cargo
  before_create :main

  def main
    h_viejo= Historial.where("persona_id = ? ",persona_id).last
    if !h_viejo.nil?
      h_viejo.cargo.disponible=true
      h_viejo.cargo.save
      if (h_viejo.fecha_inicio.day<=15 and Time.now.day>15 and Time.now.month==h_viejo.fecha_inicio.month) || (Time.now.month!=h_viejo.fecha_inicio.month)
        max=0
        if Time.now.day<=15
        if(Time.now.mon==1)
          max=Date.civil(Time.now.year-1-year,12,-1 )
        else
          max=Date.civil(Time.now.year,Time.now.month-1,-1 )
        end

        else

        max=Date.civil(Time.now.year,Time.now.mon,15 )

        end

    h_viejo.fecha_fin=max
    h_viejo.save

    else
      h_viejo.destroy
      h_viejo.save
    end
end
    cargo.disponible=false
    cargo.save


    min=0

            if Time.now.day<=15

                min=Date.civil(Time.now.year,Time.now.mon, 1)
              else
min=Date.civil(Time.now.year,Time.now.mon, 16)
            end

    self.fecha_inicio=min
    self.fecha_inicio=Time.now if $ahora.nil?
  end
end
