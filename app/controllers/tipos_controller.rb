class TiposController < ApplicationController
    before_action :set_tipo, only: [:show, :edit, :update, :destroy]

    # GET /tipos
    # GET /tipos.json
    def index
        @tipos = Tipo.all
    end

    # GET /tipos/1
    # GET /tipos/1.json
    def show
        respond_to do |format|
            format.html
            format.pdf do
              case params[:doc]
                when '0'
                    pdf = RecibosPdf.new(@tipo, 0)
                    file="Recibos_#{@tipo.nombre}"
                when '1'
                    pdf = RecibosPdf.new(@tipo, 1)
                    file="Recibos_#{@tipo.nombre}_ECO"
                when '4'
                  pdf = ConceptosPdf.new(@tipo,3)
                  file="Conceptos_#{@tipo.nombre}"
                when '5'
                  pdf = ConceptosPdf.new(@tipo,4)
                  file="Conceptos_#{@tipo.nombre}_ECO"
              end
              send_data pdf.render, filename: file, type: 'application/pdf', disposition: 'inline'

            end
        end
    end

    # GET /tipos/new
    def new
        @tipo = Tipo.new
    end

    # GET /tipos/1/edit
    def edit
    end

    # POST /tipos
    # POST /tipos.json
    def create
        @tipo = Tipo.new(tipo_params)

        respond_to do |format|
            if @tipo.save
                format.html { redirect_to @tipo, notice: 'La nómina fue creada exitosamente.' }
                format.json { render :show, status: :created, location: @tipo }
            else
                format.html { render :new }
                format.json { render json: @tipo.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /tipos/1
    # PATCH/PUT /tipos/1.json
    def update
        respond_to do |format|
            if @tipo.update(tipo_params)
                format.html { redirect_to tipos_url, notice: 'La nómina fue eliminada exitosamente.' }
                format.json { head :no_content }
            end
        end
    end

    def destroy
        @tipo.destroy
        respond_to do |format|
            format.html { redirect_to tipos_url, notice: 'La nómina fue eliminada exitosamente.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_tipo
        @tipo = Tipo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_params
        params.require(:tipo).permit(:nombre)
    end
end
