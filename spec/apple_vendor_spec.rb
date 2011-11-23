require 'spec_helper'

describe WarrantyCheck::APPLE, :focus => true do

  before(:all) do
    # @sn = "W88530XF1GK"
    # @sn = "8211276UA4S"
    @sn = "CQ12905CZ38"
    
    @vendor = WarrantyCheck::APPLE.new(@sn)
  end

  it "gets content" do
    @vendor.html =~ Regexp.new(@sn)
  end
  
  it "parses json" do
    @vendor.json.class.should == Hash
  end

  # it "does not check bad warranty" do
  #   bad_vendor = WarrantyCheck::APPLE.new("XXXXXXXXXX")
  #   bad_vendor.check
  #   bad_vendor.warranties.size.should == 0
  # end

  it "checks warranty" do
    @vendor.check
    @vendor.warranties.size.should == 2
  
    w1, w2 = @vendor.warranties
    
    w1[:description].should == "Telephone Technical Support"
    w1[:expired].should     == true
    w1[:expire_date].should == nil
  
  
    w2[:description].should == "Repairs and Service Coverage"
    w2[:expired].should     == true
    w2[:expire_date].should == nil
  end

  it "checks warranty for other serial numbers" do
    custom_vendor = WarrantyCheck::APPLE.new("CQ12905CZ38")
    custom_vendor.check
    custom_vendor.warranties.size.should == 2

    w1, w2 = custom_vendor.warranties
    
    w1[:description].should == "Telephone Technical Support"
    w1[:expired].should     == true
    w1[:expire_date].should == nil
  
  
    w2[:description].should == "Repairs and Service Coverage"
    w2[:expired].should     == true
    w2[:expire_date].should == nil
  end

end