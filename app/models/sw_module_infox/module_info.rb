module SwModuleInfox
  class ModuleInfo < ActiveRecord::Base
    attr_accessor :category_name, :last_updated_by_name, :submitted_by_name, :wf_event, :id_noupdate, :wf_comment, :wf_state_noupdate, :active_noupdate
=begin
    attr_accessible :api_spec, :about_controller, :about_init, :about_log, :about_model, :about_onboard_data, :about_subaction, :about_view, :about_workflow, 
                    :category_id, :active, :module_desp, :name, :submit_date, :wf_state, :about_misc_def, :last_updated_by_id, :submitted_by_id,:version,
                    :data_resources_attributes,
                    :as => :role_new
    attr_accessible :api_spec, :about_controller, :about_init, :about_log, :about_model, :about_onboard_data, :about_subaction, :about_view, :about_workflow, 
                    :category_id, :active, :module_desp, :name, :submit_date, :wf_state, :about_misc_def, :version, :data_resources_attributes,
                    :category_name, :last_updated_by_name, :submitted_by_name, :wf_event, :id_noupdate, :wf_comment, :wf_state_noupdate, :active_noupdate,
                    :as => :role_update
                    
    attr_accessor :start_date_s, :end_date_s, :submitted_by_id_s, :name_s, :version_s, :active_s, :category_id_s, :module_desp_s

    attr_accessible :start_date_s, :end_date_s, :submitted_by_id_s, :name_s, :version_s, :active_s, :category_id_s, :module_desp_s,
                    :as => :role_search_stats
=end                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :submitted_by, :class_name => 'Authentify::User'
    belongs_to :category, :class_name => 'Commonx::MiscDefinition'
    has_many :module_actions, :class_name => 'SwModuleInfox::ModuleAction'
    has_many :data_resources, :class_name => 'SwModuleInfox::DataResource'
    accepts_nested_attributes_for :data_resources, :allow_destroy => true
    
    validates :name, :module_desp, :presence => true
    validates :name, :uniqueness => {:scope => :version, :case_sensitive => false, :message => I18n.t('Duplicate Name!')} 
    validates :category_id, :numericality => {:only_integer => true, :greater_than => 0}, :if => 'category_id.present?'
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_info', 'sw_module_infox')
      eval(wf) if wf.present?
    end        
  end
end
