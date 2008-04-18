require 'rubygems'
require 'spec'
require 'lib/stone'

def get_resources
  @resources = Dir.glob(STONE_ROOT/"sandbox_for_specs"/"sample_resources/*")
end