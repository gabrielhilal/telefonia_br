# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'telefonia_br'
  s.version     = '0.0.2'
  s.date        = '2014-10-17'
  s.summary     = "Brazilian Phone Number Validator"
  s.description = "This gem does some tricks with Brazilian Telephone Numbers. It validates telephone numbers based on its area code, bands of operation and the rules defined by ANATEL."
  s.authors     = ["Gabriel Hilal"]
  s.email       = 'gabrielhilal@gmail.com'
  s.files       = ["lib/telefonia_br.rb", "lib/rules.rb"]
  s.homepage    = 'http://github.com/gabrielhilal/telefonia_br'
  s.license     = 'MIT'
  s.add_development_dependency "rspec"
end