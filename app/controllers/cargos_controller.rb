class CargosController < ApplicationController
  before_action :set_cargo, only: [:show, :edit, :update, :destroy]

  # GET /cargos
  # GET /cargos.json
  def index
    @cargos = Cargo.all

  end

  # GET /cargos/1
  # GET /cargos/1.json
  def show
  end

  # GET /cargos/new
  def new
    @cargo = Cargo.new
    @cargo.sueldos.build

  end

  # GET /cargos/1/edit
  def edit
  end

  # POST /cargos
  # POST /cargos.json
  def create
    @cargo = Cargo.new(cargo_params)
    #@sueldo= Sueldo.new(cargo_params['sueldo_attributes'])

    respond_to do |format|
      if @cargo.save

        format.html { redirect_to @cargo, notice: 'Cargo was successfully created.' }
        format.json { render :show, status: :created, location: @cargo }
      #  @sueldo.save
      else
        format.html { render :new }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cargos/1
  # PATCH/PUT /cargos/1.json
  def update
    respond_to do |format|

      key , value =params[:cargo][:sueldos_attributes].first;
      if@cargo.sueldos.where(:created_at => Time.now.beginning_of_month..Time.now.end_of_month).length>0
    
    else
      @cargo.sueldos.update_all(activo: false)
      @cargo.sueldos.build.monto=params[:cargo][:sueldos_attributes][key][:monto];
end
      if @cargo.update(cargo_params)
        format.html { redirect_to @cargo, notice: 'Cargo was successfully updated.' }
        format.json { render :show, status: :ok, location: @cargo }
      else
        format.html { render :edit }
        format.json { render json: @cargo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cargos/1
  # DELETE /cargos/1.json
  def destroy
    @cargo.destroy
    respond_to do |format|
      format.html { redirect_to cargos_url, notice: 'Cargo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cargo_params
      params.require(:cargo).permit(:nombre,:tipo_id, :departamento_id, sueldos_attributes:[ :id, :monto,:activo])
    end

end
