module WarrantyCheck
  
  class IBM < BaseVendor
    
    def service_base_url
      "http://support.lenovo.com"
    end
    
    def service_uri
      "/templatedata/Web%%20Content/JSP/warrantyLookup.jsp?sysSerial=%s"
    end
  
    def check
      @warranties = []
      
      table = dom.search("div table:nth-child(2)")
      
      return if table.search("tr").to_a.count == 0
      
      tds1 = table.search("tr").to_a[1].search("td")
      tds2 = table.search("tr").to_a[5].search("td")

      details_product_id      = tds1[0].text.strip
      details_type_model      = tds1[2].text.strip
      details_serial_number   = tds1[4].text.strip
      details_location        = tds2[0].text.strip
      details_expiration_date = Date.strptime(tds2[2].text.strip, "%Y-%m-%d")

      warranty = Warranty.new()
      warranty.description = ""
      warranty.expired = (details_expiration_date < Time.now ? true : false)
      warranty.expire_date = details_expiration_date
      warranty.product_id      = details_product_id     ,
      warranty.type_model      = details_type_model     ,
      warranty.serial_number   = details_serial_number  ,
      warranty.location        = details_location       ,
      warranty.expiration_date = details_expiration_date,
      
      
      @warranties << warranty
    end
  
  end
  
end
