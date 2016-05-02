class CargosController < ApplicationController
  before_filter :authenticate_usuario!
  before_action :set_cargo, only: [:show, :edit, :update, :destroy]

  # GET /cargos
  # GET /cargos.json
  def index
    s = params[:search]
    d = params[:departamento]
    p = params[:page]
    buscar = ((s != '' && s) || d)

    @cargos = buscar ? Cargo.all.search(s, d).paginate(page: p) : Cargo.order(:nombre).paginate(page: p)
    authorize! :read, @cargos

  end

  # GET /cargos/1
  # GET /cargos/1.json
  def show
  end

  # GET /cargos/new
  def new
    authorize! :create, @cargo
    @cargo = Cargo.new
    @cargo.sueldos.build
  end

  # GET /cargos/1/edit
  def edit
    authorize! :edit,@cargo
  end

  # POST /cargos
  # POST /cargos.json
  def create
    authorize! :create, @cargo
    @cargo = Cargo.new(cargo_params)
    # @sueldo= Sueldo.new(cargo_params['sueldo_attributes'])

    respond_to do |format|
      if @cargo.save
        log("Se ha credo el cargo: #{@cargo.nombre}", 1)

        format.html { redirect_to @cargo, notice: 'El cargo fue creado exitosamente.' }
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
    authorize! :update,@cargo
    respond_to do |format|
      #  if !@cargo.sueldos.where(created_at: Time.now.beginning_of_month..Time.now.end_of_month).empty?
      nuevo= false
      if $quincena == 0
        nuevo= @cargo.sueldos.where(created_at: Time.now.beginning_of_month..(Time.now.beginning_of_month + 14.days)).empty?
      else
        nuevo = @cargo.sueldos.where(created_at: (Time.now.beginning_of_month + 15.days)..Time.now.end_of_month).empty?
      end
      key, value = params[:cargo][:sueldos_attributes].first

      if nuevo

        viejo = @cargo.sueldos.where(activo: true).last

        @cargo.sueldos.update_all(activo: false)
        crear=  @cargo.sueldos.new
        crear.monto=params[:cargo][:sueldos_attributes][key][:monto]
        crear.sueldo_integral = params[:cargo][:sueldos_attributes][key][:sueldo_integral]

        params[:cargo][:sueldos_attributes][key][:monto] = viejo.monto
        params[:cargo][:sueldos_attributes][key][:sueldo_integral] = viejo.sueldo_integral

      end
      if @cargo.update(cargo_params)
        log("Se ha actualizado el cargo: #{@cargo.nombre}", 1)

        format.html { redirect_to @cargo, notice: 'Los datos del cargo fueron actualizados exitosamente.' }
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
    authorize! :destroy, @cargo.destroy
    log("Se eliminado el  cargo: #{@cargo.nombre}", 1)

    respond_to do |format|
      format.html { redirect_to cargos_url, notice: 'El cargo fue eliminado exitosamente.' }
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
    params.require(:cargo).permit(:nombre, :tipo_id, :departamento_id, sueldos_attributes: [:id, :monto, :activo, :sueldo_integral,:_destroy])
  end
end
