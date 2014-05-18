module SwModuleInfox
  class ModuleInfo < ActiveRecord::Base
    attr_accessor :category_name, :last_updated_by_name, :submitted_by_name, :wf_event, :id_noupdate, :wf_comment, :wf_state_noupdate, :in_use_noupdate
    attr_accessible :api_spec, :about_controller, :about_init, :about_log, :about_model, :about_onboard_data, :about_subaction, :about_view, :about_workflow, 
                    :category_id, :active, :module_desp, :name, :submit_date, :wf_state, :about_misc_def, :last_updated_by_id, :submitted_by_id,
                    :as => :role_new
    attr_accessible :api_spec, :about_controller, :about_init, :about_log, :about_model, :about_onboard_data, :about_subaction, :about_view, :about_workflow, 
                    :category_id, :active, :module_desp, :name, :submit_date, :wf_state, :about_misc_def,
                    :category_name, :last_updated_by_name, :submitted_by_name, :wf_event, :id_noupdate, :wf_comment, :wf_state_noupdate, :in_use_noupdate,
                    :as => :role_update
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :submitted_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
    
    validates :name, :module_desp, :presence => true
    validates :name, :uniqueness => {:case_sensitive => false, :message => 'Duplicate Name!'}
    validates :category_id, :numericality => {:only_integer => true, :greater_than => 0}, :if => 'category_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'sw_module_infox')
      eval(wf) if wf.present?
    end        
  end
end
