# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use :null_session instead.
# encoding: utf-8
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
    end

    # GET /cargos/1
    # GET /cargos/1.json
    def show
    end

    # GET /cargos/new
    def new
        authorize! :create, Cargo
        if Departamento.all.length <= 0
            respond_to do |format|
                format.html { redirect_to departamentos_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Es necesario agregar departamento.' }
            end
            return 0
          end
        if Tipo.all.length <= 0
            respond_to do |format|
                format.html { redirect_to tipos_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Es necesario agregar nómina.' }
            end
              return 0
        end
        @cargo = Cargo.new
        @cargo.sueldos.build
    end

    # GET /cargos/1/edit
    def edit
        authorize! :update, Cargo
    end

    # POST /cargos
    # POST /cargos.json
    def create
        authorize! :create, Cargo
        @cargo = Cargo.new(cargo_params)
        # @sueldo= Sueldo.new(cargo_params['sueldo_attributes'])
        respond_to do |format|
            if @cargo.save

                format.html { redirect_to @cargo, notice: '<i class="fa fa-check-square fa-lg"></i> El cargo fue creado exitosamente.' }
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
        authorize! :update, Cargo
        respond_to do |format|

            if @cargo.update(cargo_params)


                format.html { redirect_to @cargo, notice: '<i class="fa fa-check-square fa-lg"></i> Los datos del cargo fueron actualizados exitosamente.' }
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
        authorize! :destroy, Cargo
        @cargo.destroy


        respond_to do |format|
            format.html { redirect_to cargos_url, notice: '<i class="fa fa-check-square fa-lg"></i> El cargo fue eliminado exitosamente.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_cargo
        if !Cargo.where(id: params[:id]).empty?
            @cargo = Cargo.find(params[:id])

        else
            respond_to do |format|
                format.html { redirect_to cargos_url, alert: '<i class="fa fa-exclamation-triangle fa-lg"></i> Cargo no encontrado en la base de datos.' }
            end
        end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cargo_params
        params.require(:cargo).permit(:nombre, :tipo_id, :departamento_id, sueldos_attributes: [:id, :monto, :activo, :sueldo_integral, :_destroy])
    end
end
