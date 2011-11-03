require 'spec_helper'

describe WarrantyCheck::HP do

  before(:each) do
    @sn = "CND003107K"
    
    @vendor = WarrantyCheck::HP.new(@sn)
  end

  it "gets html" do
    html = @vendor.get_html
    
    html.should =~ Regexp.new(@sn)
  end
  
  it "parses html" do
    @vendor.parse_html(@vendor.get_html).class.should == Nokogiri::HTML::Document
  end
  
  it "does not check bad warranty" do
    bad_vendor = WarrantyCheck::HP.new("XXXXXXXXXX", "XXXXXXX")
    bad_vendor.check
    bad_vendor.warranties.size.should == 0
  end
  
  it "checks warranty" do
    @vendor.check
    @vendor.warranties.size.should == 2

    w1, w2 = @vendor.warranties
    
    w1[:warranty_type].should == "Base Warranty"
    w1[:service_type].should  == "Wty: HP HW Maintenance Offsite Support"
    w1[:start_date].should    == Time.strptime("21 Jan 2010", "%d %b %Y")
    w1[:end_date].should      == Time.strptime("19 Feb 2011", "%d %b %Y")
    w1[:status].should        == "Expired"
    w1[:service_level].should == "Std Office Hrs Std Office Days, Std Office Hrs Std Office Days, Global Coverage, Standard Material Handling, Standard Parts Logistics, Customer delivers to RepairCtr, No Usage Limitation, Customer Pickup at RepairCtr, 5 Business Days Turn-Around"
    w1[:deliverables].should  == "Hardware Problem Diagnosis, Offsite Support & Materials"
    
    w2[:warranty_type].should == "Base Warranty"
    w2[:service_type].should  == "Wty: HP Support for Initial Setup"
    w2[:start_date].should    == Time.strptime("21 Jan 2010", "%d %b %Y")
    w2[:end_date].should      == Time.strptime("20 May 2010", "%d %b %Y")
    w2[:status].should        == "Expired"
    w2[:service_level].should == "NextAvail TechResource Remote, Std Office Hrs Std Office Days, 2 Hr Remote Response, Unlimited Named Callers"
    w2[:deliverables].should  == "Initial Setup Assistance"
  end

end