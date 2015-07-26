module SwModuleInfox
  class ModuleAction < ActiveRecord::Base
    attr_accessor :module_info_name
=begin
    attr_accessible :name, :name_non_tech, :desp, :desp_non_tech, :last_updated_by_id, :module_info_id, :present_to_customer, :data_resource_id, :module_info_name,
                    :as => :role_new
    attr_accessible :name, :name_non_tech, :desp, :desp_non_tech, :module_info_id, :present_to_customer, :data_resource_id, :module_info_name,
                    :as => :role_update   
=end    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :module_info, :class_name => 'SwModuleInfox::ModuleInfo'
    belongs_to :data_resource, :class_name => 'SwModuleInfox::DataResource'
    
    validates :name, :presence => true,
                     :uniqueness => {:scope => [:module_info_id, :data_resource_id], :case_sensitive => false, :message => 'Duplicate Name!'} 
    validates :module_info_id, :data_resource_id, :numericality => {:only_integer => true, :greater_than => 0}
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate_action', 'sw_module_infox')
      eval(wf) if wf.present?
    end                     
  end
end
