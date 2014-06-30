module WarrantyCheck
  
  class HP < BaseVendor
      
    def service_base_url
      "http://h20000.www2.hp.com"
    end
    
    def service_uri
      "/bizsupport/TechSupport/WarrantyResults.jsp?nickname=&sn=%s&pn=&country=CA&lang=en&cc=us"
    end
      
    def check
      @warranties = []

      table = dom.search("td td table:nth-child(3)")      
      table.search("tr")[1..-1].to_a.each do |elem|
        tds = elem.search("td")
        
        next if !(6..7).include?(tds.count)
        
        @warranty_type ||= (tds.size == 7 ? tds[0].text.strip : nil)
        n = (tds.size == 7 ? 0 : -1)
        details_warranty_type = @warranty_type.gsub(/[\t\n\r]+/, "")
        details_service_type  = tds[n+1].text.strip.gsub(/[\t\n\r]+/, "")
        details_start_date    = Date.strptime(tds[n+2].text.strip, "%d %b %Y")
        details_end_date      = Date.strptime(tds[n+3].text.strip, "%d %b %Y")
        details_status        = tds[n+4].text.strip.gsub(/\s+/, "")
        details_service_level = tds[n+5].text.strip.gsub(/\st+/, "")
        details_deliverables  = tds[n+6].text.strip.gsub(/[\t\n\r]+/, "")
        
        # create new warranty object
        
          warranty = Warranty.new()
          warranty.description = "#{details_warranty_type} - #{details_service_type}"
          warranty.expired = (details_status == "Expired" ? true : false)
          warranty.warranty_type = details_warranty_type
          warranty.service_type  = details_service_type 
          warranty.start_date    = details_start_date   
          warranty.end_date      = details_end_date     
          warranty.status        = details_status       
          warranty.service_level = details_service_level
          warranty.deliverables  = details_deliverables 
          
        
    
        @warranties << warranty
      end
    end
    
  end
  
end
