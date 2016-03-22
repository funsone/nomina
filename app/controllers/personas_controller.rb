class PersonasController < ApplicationController
  before_action :set_persona, only: [:show, :edit, :update, :destroy]
$dic=Hash["tipos_de_contrato" =>Hash["fijo"=>0,"temporal"=>1,"externo"=>2],
"sexos" => Hash["Masculino"=>0,"femenino"=>1],"status"=>Hash["activo"=>0, "retirado"=>1],
"tipos_de_cedula" => Hash["V-"=>0,"E-"=>1] ]
  # GET /personas
  # GET /personas.json
  def index
    @personas = Persona.all
  end

  # GET /personas/1
  # GET /personas/1.json
  def show
  end

  # GET /personas/new
  def new
    @persona = Persona.new
    @persona.contrato= Contrato.new
  end

  # GET /personas/1/edit
  def edit
  end

  # POST /personas
  # POST /personas.json
  def create
    @persona = Persona.new(persona_params)
@persona.cargo.disponible=false
@persona.cargo.save
    respond_to do |format|
      if @persona.save

      #  Cargo.where(id: params[:cargo_id]).update_all(disponible: false);
        format.html { redirect_to @persona, notice: 'Persona was successfully created.' }
        format.json { render :show, status: :created, location: @persona }
      else
        format.html { render :new }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personas/1
  # PATCH/PUT /personas/1.json
  def update
    respond_to do |format|
      if @persona.update(persona_params)
        format.html { redirect_to @persona, notice: 'Persona was successfully updated.' }
        format.json { render :show, status: :ok, location: @persona }
      else
        format.html { render :edit }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personas/1
  # DELETE /personas/1.json
  def destroy
    @persona.cargo.update(disponible: true)
    @persona.destroy
    respond_to do |format|
      format.html { redirect_to personas_url, notice: 'Persona was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_persona
      @persona = Persona.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def persona_params
      params.require(:persona).permit(:cedula, :tipo_de_cedula, :nombres, :apellidos, :telefono_fijo, :telefono_movil,:avatar, :fecha_de_nacimiento, :correo, :direccion, :sexo, :status, :cargo_id, :cargas_familiares, contrato_attributes:[ :id, :tipo_de_contrato,:fecha_inicio,:fecha_fin,:sueldo_externo])
    end
end
