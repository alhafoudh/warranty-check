module WarrantyCheck
  
  VENDOR_PATTERNS = {
    WarrantyCheck::HP   => ["^[A-Z]{3}[0-9]{3}[0-9a-zA-Z]{4}$"], # 10
    WarrantyCheck::DELL => ["^[0-9a-zA-Z]{5,7}$"], # 5-7
    WarrantyCheck::IBM  => ["^[0-9a-zA-Z]{7}$", "^[0-9a-zA-Z]{10}$", "^[0-9a-zA-Z]{12}$"], # 7,10,12
  }
  
  def self.classify(sn)
    matched = []
    VENDOR_PATTERNS.each_pair do |vendor, regexps|
      matched << vendor if regexps.count { |rstr| r = Regexp.new(rstr); !r.match(sn).nil? } > 0
    end
    
    matched
  end
  
end