require 'rails_helper'

module SwModuleInfox
  RSpec.describe ModuleInfo, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:sw_module_infox_module_info)
      expect(c).to be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil module desp" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :module_desp => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => nil)
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject same name if version exists and are same" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => 'nil')
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => 'nil')
      expect(c).not_to be_valid
    end
    
    it "should take same name if version exists and are not the same" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => 'nilxxx')
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => 'nil')
      expect(c).to be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :category_id => 0)
      expect(c).not_to be_valid
    end
  end
end
