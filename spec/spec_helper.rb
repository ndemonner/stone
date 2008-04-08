require 'rubygems'
require 'spec'
require 'lib/stone'

def load_resources
  @resources = Dir.glob(STONE_ROOT/"sandbox_for_specs"/"sample_resources/*")
  @resources.each do |file|
    require file
  end
end

def empty_sandbox_data
  if File.exists? STONE_ROOT/"sandbox_for_specs/datastore"
    FileUtils.rm_rf STONE_ROOT/"sandbox_for_specs/datastore"
  end
end