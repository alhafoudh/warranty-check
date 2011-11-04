module WarrantyCheck
  
  class IBM < BaseVendor
    DELL_BASE_URL = "http://support.lenovo.com"
    DELL_GET_URL = "/templatedata/Web%%20Content/JSP/warrantyLookup.jsp?sysSerial=%s"
    
    attr_reader :warranties
    
    def initialize(sn)
      @sn = sn
    end
  
    def check
      @warranties = []
      
      parse_html get_html
      
      table = @dom.search("div table:nth-child(2)")
      
      return if table.search("tr").to_a.count == 0
      
      tds1 = table.search("tr").to_a[1].search("td")
      tds2 = table.search("tr").to_a[5].search("td")

      warranty = {
        :product_id      => tds1[0].text.strip,
        :type_model      => tds1[2].text.strip,
        :serial_number   => tds1[4].text.strip,
        :location        => tds2[0].text.strip,
        :expiration_date => Time.strptime(tds2[2].text.strip, "%Y-%m-%d")
      }
      
      @warranties << warranty
    end
    
    def parse_html(html)      
      @dom = Nokogiri::HTML(html)
    end
    
    def get_html
      url = URI.parse(DELL_BASE_URL)
      res = Net::HTTP.start(url.host, url.port) do |http|
        uri = sprintf(DELL_GET_URL, @sn)
        http.get(uri)
      end
      res.body
    end
  
  end
  
end