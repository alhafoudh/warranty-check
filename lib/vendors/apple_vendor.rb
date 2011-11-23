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

      @warranties << {
        :description => json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').first.strip,
        :expired => json["PH_SUPPORT_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired",
        :expire_date => nil,
        :details => json
      }
      
      @warranties << {
        :description => json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').first.strip,
        :expired => json["HW_REPAIR_COVERAGE_SUBHEADER"].split(':').last.strip == "Expired",
        :expire_date => nil,
        :details => json
      }
    end
    
  end
  
end