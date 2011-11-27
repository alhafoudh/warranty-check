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

        @warranties << {
          :description => sprintf("%s - %s", json["PROD_DESCR"].strip, json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').first.strip),
          :expired => json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired",
          :expire_date => (" " * 10),
          :details => json
        }
      
        @warranties << {
          :description => sprintf("%s - %s", json["PROD_DESCR"].strip, json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').first.strip),
          :expired => json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired",
          :expire_date => (" " * 10),
          :details => json
        }
        
      end
    end
    
    
  end
  
end