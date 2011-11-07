require 'spec_helper'

describe WarrantyCheck::DELL do

  before(:all) do
    @sn = "F34G9"
    
    @vendor = WarrantyCheck::DELL.new(@sn)
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
    
    w1[:description].should == "Rapid Response Depot (IBM)"
    w1[:expired].should     == true
    w1[:expire_date].should == Time.strptime("8/31/2001", "%m/%d/%Y")
    
    w1[:details][:description].should == "Rapid Response Depot"
    w1[:details][:provider].should    == "IBM"
    w1[:details][:start_date].should  == Time.strptime("9/1/1999", "%m/%d/%Y")
    w1[:details][:end_date].should    == Time.strptime("8/31/2001", "%m/%d/%Y")
    w1[:details][:days_left].should   == 0
  end
  
  it "checks warranty for found serial numbers" do
    custom_vendor = WarrantyCheck::DELL.new("HND96D1")
    custom_vendor.check
    custom_vendor.warranties.size.should == 1
  end

  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::DELL.new("ZZZZZ")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end

end