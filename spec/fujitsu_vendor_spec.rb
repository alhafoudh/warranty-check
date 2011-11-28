require 'spec_helper'

describe WarrantyCheck::FUJITSU, :focus => true do

  before(:all) do
    @sn = "YBMP017114"
    
    @vendor = WarrantyCheck::FUJITSU.new(@sn)
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
      
    w1[:description].should == "LIFEBOOK S7010 BT Supreme - The system has no warranty. The system was scraped"
    w1[:expired].should     == true
    w1[:expire_date].should == Time.strptime("25/09/2004", "%d/%m/%Y")
  end
  
  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::FUJITSU.new("X")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end

end