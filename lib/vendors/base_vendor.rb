require 'net/http'
require 'uri'
require 'nokogiri'
require 'time'

require 'pry'

module WarrantyCheck
  
  class BaseVendor
    
    attr_reader :html
    attr_reader :dom
    attr_reader :warranties
    
    def initialize(sn)
      @sn = sn
      @warranties = []
    end

    def check
      nil
    end
    
    def service_base_url
      "http://www.example.com"
    end
    
    def service_uri
      "/%s"
    end
    
    def url
      @url ||= URI.parse(service_base_url)
    end
    
    def uri
      @uri ||= sprintf(service_uri, @sn)
    end
    
    def html
      @html ||= get_html
    end
    
    def dom
      @dom ||= Nokogiri::HTML(html)
    end
    
    private # -----------
    
    def get_html
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.get(uri)
      end
    
      if (res.code == "302")
        @uri = res["location"]
        get_html
      else
        res.body
      end
    end

  end
  
end