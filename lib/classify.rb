module WarrantyCheck
  
  def self.classify(sn)
    case sn
    when /[A-Z]{3}[0-9a-zA-Z]{7}/
      WarrantyCheck::HP
    when /[0-9a-zA-Z]{5,7}/
      WarrantyCheck::DELL
    end
  end
  
end