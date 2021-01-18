# frozen_string_literal: true

require_relative "lib/gnomikologikon/version"

Gem::Specification.new do |spec|
  spec.name          = "gnomikologikon-fortune"
  spec.version       = Gnomika::Ruby::VERSION
  spec.authors       = ["Theodoros Grammenos"]
  spec.email         = ["teogramm@outlook.com"]

  spec.summary       = "A tool to generate cookies for the fortune command from https://gnomikologikon.gr"
  spec.description   = "This is a python script that downloads quotes from https://gnomikologikon.gr and
                        automatically converts them to files that are ready to use with the fortune command."
  spec.homepage      = "https://github.com/teogramm/gnomikologikon-fortune"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
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

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
