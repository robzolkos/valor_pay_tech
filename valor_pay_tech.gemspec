# frozen_string_literal: true

require_relative "lib/valor_pay_tech/version"

Gem::Specification.new do |spec|
  spec.name    = "valor_pay_tech"
  spec.version = ValorPayTech::VERSION
  spec.authors = ["rzolkos"]
  spec.summary = "Ruby client for the Valor PayTech API"

  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir["lib/**/*.rb"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
