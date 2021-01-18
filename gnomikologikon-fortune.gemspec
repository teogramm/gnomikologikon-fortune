# frozen_string_literal: true

require_relative "lib/gnomikologikon/version"

Gem::Specification.new do |spec|
  spec.name          = "gnomikologikon-fortune"
  spec.version       = Gnomika::Ruby::VERSION
  spec.authors       = ["Theodoros Grammenos"]
  spec.email         = ["teogramm@outlook.com"]

  spec.summary       = "A tool to generate cookies for the fortune command from https://gnomikologikon.gr"
  spec.description   = "This is a ruby application that downloads quotes from https://gnomikologikon.gr and
                        automatically converts them to files that can be used with the fortune command."
  spec.homepage      = "https://github.com/teogramm/gnomikologikon-fortune"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/teogramm/gnomikologikon-fortune"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features|.github)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~>1.10"
  spec.add_dependency "httparty"
  spec.add_dependency "ruby-progressbar"

  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
end
