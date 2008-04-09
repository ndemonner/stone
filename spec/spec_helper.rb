require 'rubygems'
require 'spec'
require 'lib/stone'

def get_resources
  @resources = Dir.glob(STONE_ROOT/"sandbox_for_specs"/"sample_resources/*")
end

def load_resources
  @resources.each do |file|
    require file
  end
end