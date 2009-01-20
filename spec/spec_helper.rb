require 'rubygems'
require 'spec'
require 'lib/stone'

module Enumerable
  def blank?
    return self.size <= 0
  end
end
class Symbol
  def blank?
    return self.to_s.size <= 0
  end
end

def get_resources
  Stone.empty_datastore
  @resources = Dir.glob(STONE_ROOT/"sandbox_for_specs"/"sample_resources/*")
end

