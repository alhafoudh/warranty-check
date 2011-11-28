require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'
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
    
    def http_method
      :get
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
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.port == 443

      res = case http_method
        when :get
          http.get(uri)
        when :post
          u = URI.parse(uri)
          http.post(u.path, u.query)
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