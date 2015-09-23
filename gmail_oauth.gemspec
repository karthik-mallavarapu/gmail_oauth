# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gmail_oauth/version'

Gem::Specification.new do |spec|
  spec.name          = "gmail_oauth"
  spec.version       = GmailOauth::VERSION
  spec.authors       = ["Karthik Mallavarapu"]
  spec.email         = ["karthik.mallavarapu@gmail.com"]
  spec.summary       = %q{A ruby gem for accessing gmail using oauth2 tokens.}
  spec.description   = %q{The library uses gmail_xoauth, mail and monkey-patched
                          ruby imap library to support gmail oauth extensions 
                          such as X-GM-THRID}
  spec.homepage      = "https://github.com/karthik-mallavarapu/gmail_oauth"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mail", '~> 2.6', ">= 2.6.3"
  spec.add_dependency "gmail_xoauth", '~> 0.4', ">= 0.4.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "coveralls", '~> 0.8.2'
  spec.add_development_dependency "rubocop", '~> 0.34'
  spec.add_development_dependency "gem-release", '~> 0.7.4'
  spec.add_development_dependency "rspec", '~> 3.3'
  spec.add_development_dependency "pry", '~> 0.10.1'
end
