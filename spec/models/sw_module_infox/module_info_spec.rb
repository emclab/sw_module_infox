require 'spec_helper'

module SwModuleInfox
  describe ModuleInfo do
    it "should be OK" do
      c = FactoryGirl.build(:sw_module_infox_module_info)
      c.should be_valid
    end
    
    it "should reject nil name" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => nil)
      c.should_not be_valid
    end
    
    it "should reject nil module desp" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :module_desp => nil)
      c.should_not be_valid
    end
    
    it "should reject duplicate name" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => nil)
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => nil)
      c.should_not be_valid
    end
    
    it "should reject same name if version exists and are same" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => 'nil')
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => 'nil')
      c.should_not be_valid
    end
    
    it "should take same name if version exists and are not the same" do
      c0 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'A name', :version => 'nilxxx')
      c = FactoryGirl.build(:sw_module_infox_module_info, :name => 'a name', :version => 'nil')
      c.should be_valid
    end
    
    it "should reject 0 category_id" do
      c = FactoryGirl.build(:sw_module_infox_module_info, :category_id => 0)
      c.should_not be_valid
    end
  end
end
