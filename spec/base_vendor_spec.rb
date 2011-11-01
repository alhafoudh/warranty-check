require 'spec_helper'

describe WarrantyCheck::BaseVendor do

  it "checks warranty" do
    vendor = WarrantyCheck::BaseVendor.new
    
    vendor.check.should == nil
  end

end