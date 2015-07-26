require 'rails_helper'

module SwModuleInfox
  RSpec.describe ModuleActionsController, type: :controller do
    routes {SwModuleInfox::Engine.routes}
    before(:each) do
      expect(controller).to receive(:require_signin)
      expect(controller).to receive(:require_employee)
    end
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @mod_info = FactoryGirl.create(:sw_module_infox_module_info)
      
      session[:user_role_ids] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id).user_role_ids
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all actions" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SwModuleInfox::ModuleAction.all.order('id')")  
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action, :last_updated_by_id => @u.id)
        qs1 = FactoryGirl.create(:sw_module_infox_module_action, :last_updated_by_id => @u.id,  :name => 'newnew')
        get 'index' 
        expect(assigns(:module_actions)).to match_array([qs, qs1])       
      end
      
      it "should return actions for module info" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SwModuleInfox::ModuleAction.all.order('id')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action, :last_updated_by_id => @u.id, :module_info_id => @mod_info.id)
        qs1 = FactoryGirl.create(:sw_module_infox_module_action, :last_updated_by_id => @u.id, :module_info_id => @mod_info.id + 1, :name => 'newnew')
        get 'index' , {:module_info_id => @mod_info.id }
        expect(assigns(:module_actions)).to match_array([qs])
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' , { :module_info_id => @mod_info.id}
        expect(response).to be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:sw_module_infox_module_action)
        get 'create' , { :module_action => qs, :module_info_id => @mod_info.id}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:sw_module_infox_module_action, :name => nil)
        get 'create' , {  :module_action => qs, :module_info_id => @mod_info.id}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action)
        get 'edit' , {  :id => qs.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action)
        get 'update' , {  :id => qs.id, :module_action => {:name => 'newnew'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action)
        get 'update' , {  :id => qs.id, :module_action => {:name => nil} }
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        res = FactoryGirl.create(:sw_module_infox_data_resource)
        qs = FactoryGirl.create(:sw_module_infox_module_action, :data_resource_id => res.id)
        get 'show' , {  :id => qs.id}
        expect(response).to be_success
      end
    end
    
    describe "GET 'destroy" do
      it "should destroy with id passed in" do
        user_access = FactoryGirl.create(:user_access, :action => 'destroy', :resource => 'sw_module_infox_module_actions', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_action)
        get 'destroy' , {  :id => qs.id, :method => :delete}
        expect(response).to redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=Successfully Deleted!")
      end
    end
  end
end
