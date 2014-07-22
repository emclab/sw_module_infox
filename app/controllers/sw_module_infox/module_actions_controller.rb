require_dependency "sw_module_infox/application_controller"

module SwModuleInfox
  class ModuleActionsController < ApplicationController
    before_filter :require_employee
    before_filter :load_parent_record

    def index
      @title = t('Actions')
      @module_actions =  params[:sw_module_infox_module_actions][:model_ar_r]
      @module_actions = @module_actions.where(:module_info_id => @module_info.id) if @module_info
      @module_actions = @module_actions.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('module_action_index_view', 'sw_module_infox')
    end

    def new
      @title = t('New Action')
      @module_action = SwModuleInfox::ModuleAction.new
      @erb_code = find_config_const('module_action_new_view', 'sw_module_infox')
    end


    def create
      @module_action = SwModuleInfox::ModuleAction.new(params[:module_action], :as => :role_new)
      @module_action.last_updated_by_id = session[:user_id]
      if @module_action.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @erb_code = find_config_const('module_action_new_view', 'sw_module_infox')
        @module_info = SwModuleInfox::ModuleInfo.find_by_id(params[:module_action][:module_info_id]) if params[:module_action].present? && params[:module_action][:module_info_id].present?
        render 'new'
      end
    end

    def edit
      @title = t('Edit Action')
      @module_action = SwModuleInfox::ModuleAction.find_by_id(params[:id])
      @erb_code = find_config_const('module_action_edit_view', 'sw_module_infox')
    end

    def update
        @module_action = SwModuleInfox::ModuleAction.find_by_id(params[:id])
        @module_action.last_updated_by_id = session[:user_id]
        if @module_action.update_attributes(params[:module_action], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @erb_code = find_config_const('module_action_edit_view', 'sw_module_infox')
          render 'edit'
        end
    end

    def show
      @title = t('Action Info')
      @module_action = SwModuleInfox::ModuleAction.find_by_id(params[:id])
      @erb_code = find_config_const('module_action_show_view', 'sw_module_infox')
    end
    
    def destroy
      SwModuleInfox::ModuleAction.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    protected
    def load_parent_record
      @module_info = SwModuleInfox::ModuleInfo.find_by_id(params[:module_info_id]) if params[:module_info_id].present?
      @module_info = SwModuleInfox::ModuleInfo.find_by_id(SwModuleInfox::ModuleAction.find_by_id(params[:id]).module_info_id) if params[:id].present?
    end
  
  end
end
