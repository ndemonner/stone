Gem::Specification.new do |s|
  s.name                  = 'stone'
  s.version               = '0.2'
  s.platform              = Gem::Platform::RUBY
  s.summary               = 'Super-simple data persistence layer created for small applications.'
  s.description           = s.summary
  s.homepage              = 'http://github.com/bomberstudios/stone/'
  s.author                = 'Ale Muñoz'
  s.email                 = 'bomberstudios@gmail.com'

  s.required_ruby_version = '>= 1.8.5'

  s.has_rdoc              = false
  s.files                 = [
    "lib/stone.rb",
    "lib/stone/callbacks.rb",
    "lib/stone/data_store.rb",
    "lib/stone/query.rb",
    "lib/stone/resource.rb",
    "lib/stone/version.rb",
    "lib/stone/core_ext/datetime.rb",
    "lib/stone/core_ext/string.rb",
    "lib/stone/core_ext/symbol.rb"
  ]
  s.require_path          = 'lib'
end