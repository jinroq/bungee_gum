# frozen_string_literal: true

require_relative 'lib/bungee_gum/version'

Gem::Specification.new do |spec|
  spec.name = 'bungee_gum'
  spec.version = BungeeGum::VERSION
  spec.authors = ['jinroq']
  spec.email = ['2787780+jinroq@users.noreply.github.com']

  spec.summary = 'This gem collects Ruby building and testing logs.'
  spec.description = 'This gem gets the latest source code from the [ruby/ruby](https://github.com/ruby/ruby) master branch. Then, build source codes in the same way as ["Building Ruby"](https://docs.ruby-lang.org/en/master/contributing/building_ruby_md.html). And also run tests (i.e. `make test-all`).'
  spec.homepage = 'https://github.com/jinroq/bungee_gum'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/jinroq/bungee_gum'
  spec.metadata['changelog_uri'] = 'https://github.com/jinroq/bungee_gum/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'git', '~> 1.18'
end
