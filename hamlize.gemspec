# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{hamlize}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonas Grimfelt"]
  s.date = %q{2009-05-02}
  s.description = %q{DRYing up your development project by converting all HTML/ERB/CSS files in a specified path (recursively) to HAML/SASS.}
  s.email = %q{grimen@gmail.com}
  s.executables = ["hamlize", "hamlize+", "sassize"]
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "MIT-LICENSE",
    "README.textile",
    "Rakefile",
    "bin/hamlize",
    "bin/hamlize+",
    "bin/sassize",
    "lib/hamlize.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/grimen/hamlize/tree/master}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{DRYing up your development project by converting all HTML/ERB/CSS files in a specified path (recursively) to HAML/SASS.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
