# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "appmospheres_audit/version"

Gem::Specification.new do |s|

  s.name        = "appmospheres_audit"
  s.version     = AppmospheresAudit::VERSION
  s.authors     = ["eugen neagoe", "Koen Handekyn"]
  s.email       = ["eugen.neagoe@appmospheres.com", "koen.handekyn@appmospheres.com"]
  s.homepage    = "https://github.com/appmospheres/appmospheres_audit"
  s.summary     = %q{A gem for tracking record changes and controller actions}
  s.description = %q{A gem for tracking record changes and controller actions}

  s.rubyforge_project = "appmospheres_audit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.licenses = ['MIT']

  s.add_dependency "rails", ">= 3.0.0"

  s.add_development_dependency "ammeter"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "rails", ">= 3.0.0"
  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"

end
