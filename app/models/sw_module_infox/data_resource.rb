module SwModuleInfox
  class DataResource < ActiveRecord::Base
#    attr_accessible :brief_note, :module_info_id, :name, :name_non_tech, :as => :role_new
#    attr_accessible :brief_note, :name, :name_non_tech, :as => :role_update
    
    belongs_to :module_info, :class_name => 'SwModuleInfox::ModuleInfo'
    
    validates :name, :presence => true, 
                     :uniqueness => {:scope => :module_info_id, :case_sensitive => false, :message => 'Duplicate Name!'}
  end
end
