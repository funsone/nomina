class SettingsController < ApplicationController
    before_action :get_setting, only: [:edit, :update]

    def index
        @settings = Setting.get_all
    end

    def show
    end

    def edit
    end

    def update
        if @setting.value != params[:setting][:value]
            @setting.value = YAML.load(params[:setting][:value])
            @setting.save
            redirect_to settings_path, notice: 'Setting has updated.'
        else
            redirect_to settings_path
        end
    end

    def get_setting
        @setting = Setting.find_by(var: params[:id]) || Setting.new(var: params[:id])
        @setting[:value] = Setting[params[:id]]
    end
end
