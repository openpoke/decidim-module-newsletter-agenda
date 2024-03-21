# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "decidim/newsletter_agenda/version"

Gem::Specification.new do |spec|
  spec.name = "decidim-newsletter_agenda"
  spec.version = Decidim::NewsletterAgenda::VERSION
  spec.authors = ["Ivan Vergés"]
  spec.email = ["ivan@pokecode.net"]

  spec.summary = "A template for the Decidim Newsletter focused on an agenda"
  spec.description = "A template for the Decidim Newsletter focused on an agenda"
  spec.license = "AGPL-3.0"
  spec.homepage = "https://github.com/openpoke/decidim-module-newsletter_agenda"
  spec.required_ruby_version = ">= 3.1"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "date_range_formatter"
  spec.add_dependency "decidim-admin", Decidim::NewsletterAgenda::COMPAT_DECIDIM_VERSION
  spec.add_dependency "decidim-core", Decidim::NewsletterAgenda::COMPAT_DECIDIM_VERSION

  spec.add_development_dependency "decidim-dev", Decidim::NewsletterAgenda::COMPAT_DECIDIM_VERSION
  spec.metadata["rubygems_mfa_required"] = "true"
end
