require 'rails_helper'

module SwModuleInfox
  RSpec.describe ModuleAction, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:sw_module_infox_module_action)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sw_module_infox_module_action, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject 0 resource_id" do
      c = FactoryGirl.build(:sw_module_infox_module_action, :data_resource_id => 0)
      expect(c).not_to be_valid
    end
    
    it "should reject duplicate name & data resource id" do
      c0 = FactoryGirl.create(:sw_module_infox_module_action, :name => 'A name')
      c = FactoryGirl.build(:sw_module_infox_module_action, :name => 'a name')
      expect(c).not_to be_valid
    end
    
    it "should take duplicate name for different data resource id" do
      c0 = FactoryGirl.create(:sw_module_infox_module_action, :name => 'A name')
      c = FactoryGirl.build(:sw_module_infox_module_action, :name => 'a name', :data_resource_id => c0.data_resource_id + 1)
      expect(c).to be_valid
    end
  end
end
