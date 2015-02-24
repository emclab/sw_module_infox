require 'rails_helper'

module SwModuleInfox
  RSpec.describe DataResource, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:sw_module_infox_data_resource)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sw_module_infox_data_resource, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:sw_module_infox_data_resource, :name => 'A name')
      c = FactoryGirl.build(:sw_module_infox_data_resource, :name => 'a name')
      expect(c).not_to be_valid
    end
  end
end
