# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.version     = "0.0.2"
  s.name        = "playmo"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Kozloff"]
  s.email       = ["andrew@tanraya.com"]
  s.homepage    = "https://github.com/tanraya/playmo"
  s.summary     = %q{This is the special kit that allows you create Rails 3 apps quick with pre-included few useful libs in your app.}
  s.description = %q{This is the special kit that allows you create Rails 3 apps quick with pre-included few useful libs in your app.}

  s.rubyforge_project = "playmo"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.has_rdoc      = false
  s.rubygems_version = %q{1.3.7}
  s.add_dependency("compass", [">= 0.10.6"])
end