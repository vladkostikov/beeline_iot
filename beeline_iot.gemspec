# frozen_string_literal: true

require_relative "lib/beeline_iot/version"

Gem::Specification.new do |spec|
  spec.name = "beeline_iot"
  spec.version = BeelineIot::VERSION
  spec.authors = ["Vladislav Kostikov"]
  spec.email = ["vlad@kostikov.ru"]

  spec.summary = "Beeline IoT M2M"
  spec.homepage = "https://github.com/vladkostikov/beeline_iot"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 1"
  spec.add_dependency "faraday", ">= 1"
  spec.add_dependency "json", ">= 1"
end
