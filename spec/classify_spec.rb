require 'spec_helper'

describe "WarrantyCheck#classify" do

  it "classifies serial numbers", :focus => true do
    WarrantyCheck::classify("CND003107K").should == [WarrantyCheck::HP, WarrantyCheck::IBM]
    WarrantyCheck::classify("F34G9").should == [WarrantyCheck::DELL]
    WarrantyCheck::classify("1qmqjh1").should == [WarrantyCheck::DELL, WarrantyCheck::IBM]
    WarrantyCheck::classify("LR18166").should == [WarrantyCheck::DELL, WarrantyCheck::IBM]
    WarrantyCheck::classify("LR18166333").should == [WarrantyCheck::IBM]
  end

end