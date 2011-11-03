require 'spec_helper'

describe "WarrantyCheck#classify" do

  it "classifies HP serial number" do
    WarrantyCheck::classify("CND003107K").should == WarrantyCheck::HP
  end

  it "classifies DELL serial number" do
    WarrantyCheck::classify("F34G9").should == WarrantyCheck::DELL
    WarrantyCheck::classify("1qmqjh1").should == WarrantyCheck::DELL
  end

end