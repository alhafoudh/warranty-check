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
        puts "Start: #{tds[n+2].text.strip}"
        puts "Start: #{tds[n+3].text.strip}"
        details_warranty_type = @warranty_type
        details_service_type  = tds[n+1].text.strip
        details_start_date    = Date.strptime(tds[n+2].text.strip, "%d %b %Y")
        details_end_date      = Date.strptime(tds[n+3].text.strip, "%d %b %Y")
        details_status        = tds[n+4].text.strip
        details_service_level = tds[n+5].text.strip
        details_deliverables  = tds[n+6].text.strip
        
        warranty = {
          :description => "#{details_warranty_type} - #{details_service_type}",
          :expired => (details_status == "Expired" ? true : false),
          :expire_date => details_end_date,
          
          :details => {
            :warranty_type => details_warranty_type,
            :service_type  => details_service_type ,
            :start_date    => details_start_date   ,
            :end_date      => details_end_date     ,
            :status        => details_status       ,
            :service_level => details_service_level,
            :deliverables  => details_deliverables ,
          }
        }
    
        @warranties << warranty
      end
    end
    
  end
  
end
