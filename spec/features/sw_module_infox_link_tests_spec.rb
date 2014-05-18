require 'spec_helper'

describe "LinkTests" do
  describe "GET /sw_module_infox_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @cate = FactoryGirl.create(:commonx_misc_definition, :for_which => 'module_category')
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource => 'sw_module_infox_module_infos',  :role_definition_id => @role.id, :rank => 1,
        :sql_code => "SwModuleInfox::ModuleInfo.scoped.order('id DESC')")     
        
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'sw_module_infox_module_infos', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'sw_module_infox_module_infos', :masked_attrs => '-start_date, -expire_date', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_module_info', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      qs1 = FactoryGirl.create(:sw_module_infox_module_info, :last_updated_by_id => @u.id, :submit_date => 10.days.ago)
        
      visit module_infos_path
      save_and_open_page
      page.should have_content('Module Infos')
      click_link 'Edit'
      page.should have_content('Edit Module Info')
      save_and_open_page
      fill_in 'module_info_name', :with => 'a test bom'
      click_button 'Save'
      #with wrong data
      visit module_infos_path
      #save_and_open_page
      page.should have_content('Module Infos')
      click_link 'Edit'
      fill_in 'module_info_module_desp', :with => ''
      click_button 'Save'
      save_and_open_page
      
      visit module_infos_path
      click_link qs1.id.to_s
      save_and_open_page
      page.should have_content('Module Info')
      click_link 'New Log'
      save_and_open_page
      page.should have_content('Log')
      
      visit new_module_info_path()
      save_and_open_page
      page.should have_content('New Module Info')
      fill_in 'module_info_name', :with => 'a test bom'
      fill_in 'module_info_module_desp', :with => 'a test spec'
      fill_in 'module_info_submit_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      #with wrong data
      visit new_module_info_path
      fill_in 'module_info_name', :with => ''
      fill_in 'module_info_module_desp', :with => 'a test spec'
      fill_in 'module_info_submit_date', :with => Date.today
      click_button 'Save'
      #save_and_open_page
      
    end
  end
end
