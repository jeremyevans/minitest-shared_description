spec = Gem::Specification.new do |s|
  s.name = 'minitest-shared_description'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.rdoc_options += ["--quiet", "--line-numbers", "--inline-source", '--title', 'minitest-shared_description: support for shared specs and shared spec subclasses', '--main', 'README.rdoc']
  s.license = "MIT"
  s.summary = "Support for shared specs and shared spec subclasses for Minitest"
  s.author = "Jeremy Evans"
  s.email = "code@jeremyevans.net"
  s.homepage = "http://github.com/jeremyevans/minitest-shared_description"
  s.files = %w(MIT-LICENSE CHANGELOG README.rdoc Rakefile) + Dir["{spec,lib}/**/*.rb"]
  s.description = <<END
minitest-shared_description adds support for shared specs and shared spec subclasses
to Minitest.  Minitest supports shared specs by default using plain ruby modules, but
does not support shared spec subclasses.  In addition to making it possible to share
subclasses, minitest-shared_desciption also provides a slightly nicer interface for
sharing specs.
END

  s.add_development_dependency "minitest", '>5'
end
