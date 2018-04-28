Gem::Specification.new do |s|
  s.name        = 'ksmyvoteinfo'
  s.version     = '1.0.0'
  s.date        = '2018-04-28'
  s.summary     = "Interact with the KS SOS voter registration search form"
  s.description = "Naive scraper of the Kansas voter registration search"
  s.authors     = ["Peter Karman"]
  s.email       = 'peter@peknet.com'
  s.files       = ["lib/ksmyvoteinfo.rb"]
  s.homepage    = 'http://rubygems.org/gems/ksmyvoteinfo'
  s.license     = 'MIT'

  s.add_runtime_dependency 'mechanize', '~> 0'
  s.add_runtime_dependency 'nokogiri', '~> 0'
end
