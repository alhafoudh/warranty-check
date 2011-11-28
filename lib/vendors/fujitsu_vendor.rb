module WarrantyCheck
  
  class FUJITSU < BaseVendor
    
    def service_base_url
      "http://sali.uk.ts.fujitsu.com"
    end
    
    def service_uri
      "/ServiceEntitlement/service.asp?snr=%s&x=0&y=0&command=search"
    end
    
    def http_method
      :post
    end
  
    def check
      @warranties = []
      
      table = dom.search("table").to_a[3]
      return unless table.search("tr").to_a.count == 4
      
      td1 = table.search("tr").to_a[1].search("td").to_a[1].text.strip
      td2 = table.search("tr").to_a[2].search("td").to_a[1].text.strip
      td3 = table.search("tr").to_a[3].search("td").to_a[1].text.strip

      return if td1 =~ /^Error/

      expiration_date = Time.strptime(td3, "%d/%m/%Y")
      
      warranty = {
        :description => sprintf("%s - %s", td1, td2),
        :expired => (expiration_date < Time.now ? true : false),
        :expire_date => expiration_date
      }
      
      @warranties << warranty
    end
  
  end
  
end