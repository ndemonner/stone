module Stone
  module Resource
    attr_accessor :validations
    
    def self.included(includer)
      includer.extend(self)
      
      includer.class_eval do
        
        def initialize(*attributes)
          attributes.first.each {|k,v| instance_variable_set("@#{k}", v)} unless attributes.empty?
        end
        
        def validate!
        end
        
        def valid?
          true
        end
        
        def serialize!
          true
        end
        
        def save
          validate!
          if valid? && serialize!
            true
          else
            false
          end
        end
        
      end
    end
    
    def create(*attributes)
      obj = self.new(attributes)
      obj.validate!
      if obj.valid? && obj.serialize!
        obj
      else
        false
      end
    end
    
    def field(name)
      self.class_eval do
        attr_accessor name        
      end
    end
    
    def validate(field_name, &block)
      @validations ||= Hash.new
      @validations[field_name] = block
    end
  end
end