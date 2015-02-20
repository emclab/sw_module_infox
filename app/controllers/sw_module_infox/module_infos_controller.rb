require_dependency "sw_module_infox/application_controller"

module SwModuleInfox
  class ModuleInfosController < ApplicationController
    before_action :require_employee
    before_action :load_parent_record

    def index
      @title = t('Module Infos')
      @module_infos =  params[:sw_module_infox_module_infos][:model_ar_r]
      @module_infos = @module_infos.where(:category_id => @category.id) if @category
      @module_infos = @module_infos.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('module_info_index_view', 'sw_module_infox')
    end

    def new
      @title = t('New Module Info')
      @module_info = SwModuleInfox::ModuleInfo.new
      @erb_code = find_config_const('module_info_new_view', 'sw_module_infox')
    end


    def create
      @module_info = SwModuleInfox::ModuleInfo.new(params[:module_info], :as => :role_new)
      @module_info.submitted_by_id = session[:user_id]
      @module_info.last_updated_by_id = session[:user_id]
      if @module_info.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('module_info_new_view', 'sw_module_infox')
        @customer = SwModuleInfox.customer_class.find_by_id(params[:module_info][:customer_id]) if params[:module_info].present? && params[:module_info][:customer_id].present?
        render 'new'
      end
    end

    def edit
      @title = t('Edit Module Info')
      @module_info = SwModuleInfox::ModuleInfo.find_by_id(params[:id])
      @erb_code = find_config_const('module_info_edit_view', 'sw_module_infox')
    end

    def update
        @module_info = SwModuleInfox::ModuleInfo.find_by_id(params[:id])
        @module_info.last_updated_by_id = session[:user_id]
        if @module_info.update_attributes(params[:module_info], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('module_info_edit_view', 'sw_module_infox')
          render 'edit'
        end
    end

    def show
      @title = t('Module Info')
      @module_info = SwModuleInfox::ModuleInfo.find_by_id(params[:id])
      @erb_code = find_config_const('module_info_show_view', 'sw_module_infox')
    end
    
    protected
    def load_parent_record
      @category = Commonx::MiscDefinition.find_by_id(params[:category_id]) if params[:category_id].present?
      sw_mod = SwModuleInfox::ModuleInfo.find_by_id(params[:id]) if params[:id].present?
      @category = Commonx::MiscDefinition.find_by_id(sw_mod.category_id) if sw_mod
    end
  end
end
