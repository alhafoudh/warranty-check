require 'spec_helper'

describe WarrantyCheck::BaseVendor do

  it "checks warranty" do
    vendor = WarrantyCheck::BaseVendor.new("test")
    vendor.check
    vendor.warranties.size.should == 0
  end

end