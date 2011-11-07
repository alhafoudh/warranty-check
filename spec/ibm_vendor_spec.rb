require 'spec_helper'

describe WarrantyCheck::IBM do

  before(:all) do
    @sn = "LR18166"
    
    @vendor = WarrantyCheck::IBM.new(@sn)
  end

  it "gets html" do
    @vendor.html =~ Regexp.new(@sn)
  end

  it "parses html" do
    @vendor.dom.class.should == Nokogiri::HTML::Document
  end

  it "checks warranty" do
    @vendor.check
    @vendor.warranties.size.should == 1
    
    w1 = @vendor.warranties.first
      
    w1[:description].should == ""
    w1[:expired].should     == true
    w1[:expire_date].should == Time.strptime("2010-03-06", "%Y-%m-%d")
    
    w1[:details][:product_id].should      == "2511H7U"
    w1[:details][:type_model].should      == "2511-H7U"
    w1[:details][:serial_number].should   == "LR18166"
    w1[:details][:location].should        == "Canada"
    w1[:details][:expiration_date].should == Time.strptime("2010-03-06", "%Y-%m-%d")
  end
  
  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::IBM.new("XXXXXXX")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end

end