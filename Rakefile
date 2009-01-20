# require 'config/requirements'
# require 'config/hoe' # setup Hoe + all gem configuration
require "rake"
require 'fileutils'
require "rake/clean"
require 'rake/gempackagetask'
require "spec/rake/spectask"
require 'lib/stone'

Dir['tasks/**/*.rake'].each { |rake| load rake }

Spec::Rake::SpecTask.new('specs') do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = Dir['spec/**/*_spec.rb'].sort
end

desc "Run specs"
task :ok do
  Stone.empty_datastore
  FileUtils.rm(Dir.pwd/"sandbox_for_specs"/"stone.sql") \
    if File.exists? Dir.pwd/"sandbox_for_specs"/"stone.sql"
  sh "rake specs"
end

desc "Check if gem will work in Github"
task :github do
  require 'rubygems/specification'
  data = File.read('stone.gemspec')
  github_spec = nil
  Thread.new { github_spec = eval("$SAFE = 3\n#{data}") }.join
  puts github_spec
end

CLOBBER.include [ 'pkg' ]
load 'stone.gemspec'
Rake::GemPackageTask.new(@spec) { |task| }