require 'spec_helper'

module SwModuleInfox
  describe DataResource do
    it "should be OK" do
      c = FactoryGirl.build(:sw_module_infox_data_resource)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sw_module_infox_data_resource, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:sw_module_infox_data_resource, :name => 'A name')
      c = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'a name')
      c.should_not be_valid
    end
  end
end
