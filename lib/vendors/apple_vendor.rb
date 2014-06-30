module WarrantyCheck
  
  class APPLE < BaseVendor
      
    def service_base_url
      "https://selfsolve.apple.com"
    end
    
    def service_uri
      "/warrantyChecker.do?sn=%s"
    end
    
    def json
      @json ||= JSON.parse(html.slice(5, html.length - 6))
    end
      
    def check
      @warranties = []
      
      if json["ERROR_CODE"].nil?
        w1 = Warranty.new()
        w1.description = sprintf("%s - %s", json["PROD_DESCR"].strip,
                                 json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').first.strip)
        w1.expired = json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired"
        w1.expire_date = (" " * 10)
        w1.details = json
        @warranties << w1
        w2 = Warranty.new()
        w2.description = sprintf("%s - %s", json["PROD_DESCR"].strip,
                                 json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').first.strip)
        w2.expired = json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired"
        w2.expire_date = (" " * 10)
        w2.details = json
        @warranties << w2
      end
    end
    
    
  end
  
end
