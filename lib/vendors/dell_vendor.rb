module WarrantyCheck
  
  class DELL < BaseVendor

    def service_base_url
      "http://support.dell.com"
    end
    
    def service_uri
      "/support/topics/global.aspx/support/my_systems_info/details?c=us&cs=08&l=en&s=pub&servicetag=%s"
    end
    
    def check
      @warranties = []
      
      table = dom.search("table.contract_table")
      table.search("tr")[1..-1].to_a.each do |elem|
        tds = elem.search("td")

        details_description = tds[0].text.strip
        details_provider    = tds[1].text.strip
        details_start_date  = Date.strptime(tds[2].text.strip, "%m/%d/%Y")
        details_end_date    = Date.strptime(tds[3].text.strip, "%m/%d/%Y")
        details_days_left   = tds[4].text.strip.to_i
        
        warranty = {
          :description => "#{details_description} (#{details_provider})",
          :expired => (details_days_left == 0 ? true : false),
          :expire_date => details_end_date,
          
          :details => {
            :description => details_description,
            :provider    => details_provider   ,
            :start_date  => details_start_date ,
            :end_date    => details_end_date   ,
            :days_left   => details_days_left  
          }
        }
        
        @warranties << warranty
      end
    end
  
  end
  
end
