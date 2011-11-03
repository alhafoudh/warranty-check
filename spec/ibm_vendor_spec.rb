require 'spec_helper'

describe WarrantyCheck::IBM do

  before(:each) do
    @sn = "LR18166"
    
    @vendor = WarrantyCheck::IBM.new(@sn)
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
      
    w1[:product_id].should == "2511H7U"
    w1[:type_model].should    == "2511-H7U"
    w1[:serial_number].should  == "LR18166"
    w1[:location].should    == "Canada"
    w1[:expiration_date].should   == Time.strptime("2010-03-06", "%Y-%m-%d")
  end
  
  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::DELL.new("XXXXXXX")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end

end