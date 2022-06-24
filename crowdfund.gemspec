Gem::Specification.new do |s|
    s.name         = "crowdfund"
    s.version      = "1.0.2"
    s.author       = "Jamie Clark"
    s.email        = "clarkcjamie@gmail.com"
    s.homepage     = "http://pragmaticstudio.com" 

    s.summary      = "Text based game for fundraising projects featuring rounds, donation pledge tiers, and fundraising statistics"
    s.description  = File.read(File.join(File.dirname(__FILE__), 'README.txt'))
    s.licenses     = ['MIT']
  
    s.files         = Dir["{bin,lib,spec}/**/*"] + %w(LICENSE.txt README.txt) #altered line
    s.test_files    = Dir["spec/**/*"]
    s.executables   = [ 'crowdfund' ] #altered line to  just say 'game.rb' #REMOVED "DIR" AND IT WORKED
  
    s.required_ruby_version = '>=1.9'
    s.add_development_dependency 'rspec', '~> 2.8', '>= 2.8.0'
  end