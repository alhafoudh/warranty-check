require 'spec_helper'

describe WarrantyCheck::DELL do

  before(:each) do
    @sn = "F34G9"
    
    @vendor = WarrantyCheck::DELL.new(@sn)
  end

  it "gets html" do
    html = @vendor.get_html
    
    html.should =~ Regexp.new(@sn)
  end

  it "parses html" do
    @vendor.parse_html(@vendor.get_html).class.should == Nokogiri::HTML::Document
  end
  
  it "checks warranty" do
    @vendor.check
    @vendor.warranties.size.should == 1
    
    w1 = @vendor.warranties.first
    
    w1[:description].should == "Rapid Response Depot"
    w1[:provider].should    == "IBM"
    w1[:start_date].should  == Time.strptime("9/1/1999", "%m/%d/%Y")
    w1[:end_date].should    == Time.strptime("8/31/2001", "%m/%d/%Y")
    w1[:days_left].should   == 0
  end

  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::DELL.new("ZZZZZ")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end

end