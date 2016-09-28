Gem::Specification.new do |s|
  s.name          = 'canvas-tools'
  s.version       = '0.0.2'
  s.date          = '2016-09-26'
  s.summary       = "Basic commmand line tools for canvas"
  s.description   = ""
  s.authors       = ["Dr. Ogg"]
  s.email         = ["ogg@sr375.com"]
  # s.files         = ["lib/canvas-tools.rb"]
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.homepage      = ''
  s.license       = 'MIT'

  s.add_dependency "bundler", "~> 1.12"
  s.add_dependency "rake", "~> 10.0"
  s.add_dependency 'console_table', '~> 0.2.4'
  s.add_dependency 'colorize', '~> 0.8.1'
  s.add_dependency 'rest-client', '~> 2.0.0'


end
