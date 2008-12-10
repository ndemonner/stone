# Fixes the bug with YAML and DateTime, where
# YAML::load(DateTime.now.to_yaml).class == Time
require "yaml"
class DateTime
  yaml_as "tag:ruby.yaml.org,2002:datetime"
  def DateTime.yaml_new(klass, tag, val)
    if String === val
      self.parse(val)
    else
      raise YAML::TypeError, "Invalid DateTime: " + val.inspect
    end
  end
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.scalar( taguri, self.to_s, :plain )
    end
  end
end