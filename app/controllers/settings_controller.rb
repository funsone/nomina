class SettingsController < ApplicationController
    before_action :get_setting, only: [:edit, :update]

    def index
      authorize! :read, Setting
        @settings = Setting.get_all

    end

    def show
          authorize! :read, Setting
    end

    def edit
        authorize! :update, Setting
    end

    def update
        if @setting.value != params[:setting][:value]
            @setting.value = YAML.load(params[:setting][:value])
            @setting.save
              authorize! :update, Setting
            redirect_to settings_path, notice: 'La configuracion fue actualizada exitosamente.'
        else
            redirect_to settings_path
        end
    end

    def get_setting
        @setting = Setting.find_by(var: params[:id]) || Setting.new(var: params[:id])
        @setting[:value] = Setting[params[:id]]
    end
end
