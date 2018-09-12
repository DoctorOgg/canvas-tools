Gem::Specification.new do |s|
  s.name          = 'canvas-tools'
  s.version       = '0.0.4'
  s.date          = '2018-09-18'
  s.summary       = "Basic commmand line tools for canvas"
  s.description   = s.summary
  s.authors       = ["Dr. Ogg"]
  s.email         = ["ogg@sr375.com"]
  s.executables   = [ "canvas-addusers.rb" ]
  s.bindir        = "exe"
  s.homepage      = 'http://sr375.com'
  s.license       = 'MIT'


  s.add_dependency "bundler", "~> 1.16"
  s.add_dependency "rake", "~> 12.3"
  s.add_dependency 'console_table', '~> 0.3.0'
  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'rest-client', '~> 2.0.2'

end
