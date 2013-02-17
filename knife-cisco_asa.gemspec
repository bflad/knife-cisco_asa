# -*- encoding: utf-8 -*-
require File.expand_path('../lib/knife-cisco_asa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Brian Flad"]
  gem.email         = ["bflad417@gmail.com"]
  gem.description   = %q{A knife plugin for managing Cisco ASA devices.}
  gem.summary       = gem.summary
  gem.homepage      = "https://github.com/bflad/knife-cisco_asa"

  gem.add_runtime_dependency "cisco"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "knife-cisco_asa"
  gem.require_paths = ["lib"]
  gem.version       = Knife::CiscoAsa::VERSION
end
