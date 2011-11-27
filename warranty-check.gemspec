Gem::Specification.new do |s|
  s.name        = 'warranty-check'
  s.version     = '1.1.3'
  s.date        = '2011-11-27'
  s.summary     = "Warranty check"
  s.description = "The library retrieves warrany information from various vendor websites based in provided SN/PN"
  s.authors     = ["Ahmed Al Hafoudh"]
  s.email       = ["alhafoudh@freevision.sk"]
  s.homepage    = "http://github.com/freevision/warranty-check"
  
  s.files       = `git ls-files`.split("\n") 
  
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  
  s.require_paths = ["lib"]
  
  s.add_dependency 'nokogiri'
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'pry'
end