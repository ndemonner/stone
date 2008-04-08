require 'config/requirements'
require 'config/hoe' # setup Hoe + all gem configuration
require "rake"
require "rake/clean"
require "spec/rake/spectask"
require 'lib/stone'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Spec::Rake::SpecTask.new('specs') do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = Dir['spec/**/*_spec.rb'].sort
end

desc "Run specs"
task :ok do
  sh "rake specs"
end