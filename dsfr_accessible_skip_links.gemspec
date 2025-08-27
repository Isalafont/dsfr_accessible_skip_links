# frozen_string_literal: true

require_relative "lib/dsfr_accessible_skip_links/version"

Gem::Specification.new do |spec|
  spec.name = "dsfr_accessible_skip_links"
  spec.version = DsfrAccessibleSkipLinks::VERSION
  spec.authors = ["Isabelle Lafont"]
  spec.email = ["isalafont@gmail.com"]
  spec.summary = "Accessible skip links implementation following DSFR (Système de design de l'État français) guidelines"
  spec.description = "A Ruby gem that helps projects implement accessible skip links according to " \
                     "the French government design system (DSFR). Provides helpers and utilities " \
                     "for creating navigation skip links that improve accessibility."
  spec.homepage = "https://github.com/Isalafont/dsfr_accessible_skip_links"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Isalafont/dsfr_accessible_skip_links"
  spec.metadata["changelog_uri"] = "https://github.com/Isalafont/dsfr_accessible_skip_links/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.post_install_message = <<~MSG
    Thank you for installing dsfr_accessible_skip_links (v#{DsfrAccessibleSkipLinks::VERSION})!

    To complete setup in your Rails app, run:
      bin/rails g dsfr_accessible_skip_links:install

    This will copy the skip links partial and inject the render call into your application layout.
  MSG

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z 2>/dev/null`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rubocop-rake", "~> 0.6"
  spec.add_development_dependency "rubocop-rspec", "~> 2.0"
end
