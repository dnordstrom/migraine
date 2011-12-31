# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "migraine/version"

Gem::Specification.new do |s|
  s.name        = "migraine"
  s.version     = Migraine::VERSION
  s.authors     = ["Daniel Nordstrom"]
  s.email       = ["d@nintera.com"]
  s.homepage    = ""
  s.summary     = %q{Simple data migration scripts in Ruby.}
  s.description = %q{Avoid a migraine when migrating your data from one database to another. Simply specify which, and where, tables and columns should be migrated.}

  s.rubyforge_project = "migraine"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "sequel"
end
