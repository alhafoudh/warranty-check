module WarrantyCheck
  
  class HP < BaseVendor
    HP_BASE_URL = "http://h20000.www2.hp.com"
    HP_GET_URL = "/bizsupport/TechSupport/WarrantyResults.jsp?nickname=&sn=%s&pn=%s&country=%s&lang=en&cc=us"
    
    attr_reader :warranties
    
    def initialize(sn, pn = nil, country = "CA")
      @sn = sn
      @pn = pn
      @country = country
    end
  
    def check
      parse_html get_html
      
      table = @dom.search("td td table:nth-child(3)")
      
      @warranties = []
      table.search("tr")[1..-1].to_a.each do |elem|
        tds = elem.search("td")
        
        @warranty_type ||= (tds.size == 7 ? tds[0].text.strip : nil)
        n = (tds.size == 7 ? 0 : -1)
        
        warranty = {
          :warranty_type => @warranty_type,
          :service_type  => tds[n+1].text.strip,
          :start_date    => Time.parse(tds[n+2].text.strip),
          :end_date      => Time.parse(tds[n+3].text.strip),
          :status        => tds[n+4].text.strip,
          :service_level => tds[n+5].text.strip,
          :deliverables  => tds[n+6].text.strip
        }
        
        @warranties << warranty
      end
    end
    
    def parse_html(html)      
      @dom = Nokogiri::HTML(html)
    end
    
    def get_html
      url = URI.parse(HP_BASE_URL)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.get(sprintf(HP_GET_URL, @sn, @pn, @country))
      end
      
      res.body
    end
  
  end
  
end