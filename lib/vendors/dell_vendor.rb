module WarrantyCheck
  
  class DELL < BaseVendor
    DELL_BASE_URL = "http://support.dell.com"
    DELL_GET_URL = "/support/topics/global.aspx/support/my_systems_info/details?c=us&cs=08&l=en&s=pub&servicetag=%s"
    
    attr_reader :warranties
    
    def initialize(sn)
      @sn = sn
    end
  
    def check
      parse_html get_html
      
      table = @dom.search("table.contract_table")
      
      @warranties = []
      table.search("tr")[1..-1].to_a.each do |elem|
        tds = elem.search("td")
        
        warranty = {
          :description => tds[0].text.strip,
          :provider    => tds[1].text.strip,
          :start_date  => Time.strptime(tds[2].text.strip, "%m/%d/%Y"),
          :end_date    => Time.strptime(tds[3].text.strip, "%m/%d/%Y"),
          :days_left   => tds[4].text.strip.to_i
        }
        
        @warranties << warranty
      end
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