module WarrantyCheck
  
  class DELL < BaseVendor
    DELL_BASE_URL = "http://support.dell.com"
    DELL_GET_URL = "/support/topics/global.aspx/support/my_systems_info/details?c=us&cs=08&l=en&s=pub&servicetag=%s"
    
    attr_reader :warranties
    
    def initialize(sn)
      @sn = sn
      
      @url = URI.parse(DELL_BASE_URL)
      @uri = sprintf(DELL_GET_URL, @sn)
    end
  
    def check
      @warranties = []
      
      parse_html get_html
      
      table = @dom.search("table.contract_table")
      table.search("tr")[1..-1].to_a.each do |elem|
        tds = elem.search("td")

        details_description = tds[0].text.strip
        details_provider    = tds[1].text.strip
        details_start_date  = Time.strptime(tds[2].text.strip, "%m/%d/%Y")
        details_end_date    = Time.strptime(tds[3].text.strip, "%m/%d/%Y")
        details_days_left   = tds[4].text.strip.to_i
        
        warranty = {
          :description => "#{details_description} (#{details_provider})",
          :expired => (details_days_left == 0 ? true : false),
          :expire_date => details_end_date,
          
          :details => {
            :description => details_description,
            :provider    => details_provider   ,
            :start_date  => details_start_date ,
            :end_date    => details_end_date   ,
            :days_left   => details_days_left  
          }
        }
        
        @warranties << warranty
      end
    end
    
    def parse_html(html)      
      @dom = Nokogiri::HTML(html)
    end
    
    def get_html
      res = Net::HTTP.start(@url.host, @url.port) do |http|
        http.get(@uri)
      end
      
      if (res.code == "302")
        @uri = res["location"]
        get_html
      else
        res.body
      end
    end
    
    def get_res
      url = URI.parse(DELL_BASE_URL)
      res = Net::HTTP.start(url.host, url.port) do |http|
        uri = sprintf(DELL_GET_URL, @sn)
        http.get(uri)
      end
      res
    end
  
  end
  
end