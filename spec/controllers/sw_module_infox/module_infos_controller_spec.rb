require 'rails_helper'

module SwModuleInfox
  RSpec.describe ModuleInfosController, type: :controller do
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
      
      @cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'module_info')
      
    end
      
    render_views
    
    describe "GET 'index'" do
      it "returns all moduless for regular user" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SwModuleInfox::ModuleInfo.all.order('id')")  
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        resource = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'data resource new')
        resource1 = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'data resource')      
        qs = FactoryGirl.create(:sw_module_infox_module_info, :last_updated_by_id => @u.id, :data_resources => [resource])
        qs1 = FactoryGirl.create(:sw_module_infox_module_info, :last_updated_by_id => @u.id,  :name => 'newnew', :data_resources => [resource1])
        get 'index' 
        expect(assigns(:module_infos)).to match_array([qs, qs1])       
      end
      
      it "should return project for the category_id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SwModuleInfox::ModuleInfo.all.order('id')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        resource = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'data resource new')
        resource1 = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'data resource')      
        qs = FactoryGirl.create(:sw_module_infox_module_info, :last_updated_by_id => @u.id, :category_id => @cate.id, :data_resources => [resource])
        qs1 = FactoryGirl.create(:sw_module_infox_module_info, :last_updated_by_id => @u.id, :category_id => @cate.id + 1, :name => 'newnew', :data_resources => [resource1])
        get 'index' , {:use_route =>  :sw_module_infox, :category_id => @cate.id }
        expect(assigns(:module_infos)).to match_array([qs])
      end
      
    end
  
    describe "GET 'new'" do
      
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new' 
        expect(response).to be_success
      end
           
    end
  
    describe "GET 'create'" do
      it "redirect for a successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        resource = FactoryGirl.attributes_for(:sw_module_infox_data_resource, :name => 'data resource new')
        qs = FactoryGirl.attributes_for(:sw_module_infox_module_info, :data_resources_attributes => [resource])
        get 'create' , { :module_info => qs}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.attributes_for(:sw_module_infox_module_info, :name => nil)
        get 'create' , { :module_info => qs}
        expect(response).to render_template("new")
      end
    end
  
    describe "GET 'edit'" do
      
      it "returns http success for edit" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_info)
        get 'edit' , { :id => qs.id}
        expect(response).to be_success
      end
      
    end
  
    describe "GET 'update'" do
      
      it "redirect if success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        resource = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'data resource new')
        qs = FactoryGirl.create(:sw_module_infox_module_info, :data_resources => [resource])
        get 'update' , { :id => qs.id, :module_info => {:name => 'newnew'}}
        expect(response).to redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render 'new' if data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        qs = FactoryGirl.create(:sw_module_infox_module_info)
        get 'update' , { :id => qs.id, :module_info => {:name => nil}}
        expect(response).to render_template("edit")
      end
    end
  
    describe "GET 'show'" do
      
      it "should show" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource => 'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        res = FactoryGirl.build(:sw_module_infox_data_resource)
        qs = FactoryGirl.create(:sw_module_infox_module_info, :data_resources => [res])
        get 'show' , { :id => qs.id}
        expect(response).to be_success
      end
    end
  end
end
