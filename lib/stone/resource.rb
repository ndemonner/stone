module Stone
  module Resource
    attr_accessor :validations
    attr_accessor :fields
    attr_accessor :storage
    
    def self.included(includer)
      includer.extend(self)
      @storage = :memory
      
      includer.class_eval do
        
        attr_accessor :errors
        attr_accessor :id
        
        def initialize(*attributes)
          @id = Stone.serializer.new_id(self)
          attributes.first.each {|k,v| instance_variable_set("@#{k}", v)} unless attributes.empty?
          @errors = []
        end
        
        def valid?
          validate!
          errors.empty?
        end
        
        def serialize!
          Stone.serializer.write(self)
          if self.class.in_memory?
            if self.id == 1 
              Stone.map[self.class] = [{self.id => self}]
            else
              Stone.map[self.class] << {self.id => self}
            end
          end
        end
        
        def save
          if valid? && serialize!
            self
          else
            false
          end
        end
        
        private
        def validate!
          vals = self.class.validations
          fields = self.class.fields
          
          fields.each do |f|
            if vals[f]
              unless vals[f].call(self.send(f))
                errors << f
              end
            end
          end
        end
        
      end
    end
    
    def create(*attributes)
      obj = self.new(attributes)
      obj.save
    end
    
    def field(name)
      @fields ||= []
      @fields << name
      self.class_eval do
        attr_accessor name        
      end
    end
    
    def validate(field_name, &block)
      @validations ||= Hash.new
      @validations[field_name] = block
    end
    
    def get(id)
      if in_file?
        obj = Stone.serializer.read_one(self, id) || nil
      else
        obj = Stone.map[self][id] || nil
      end
      obj
    end
    
    def [](id)
      if in_file?
        obj = Stone.serializer.read_one(self, id) || nil
      else
        obj = Stone.map[self][id] || nil
      end
      obj
    end
    
    def all
      if in_file?
        results = Stone.serializer.read_all(self) || []
      else
        results = Stone.map[self] || []
      end
      if block_given?
        new_results = []
        results.each do |r|
          if yield(r)
            new_results << r
          end
        end
        results = new_results
      end
      results
    end
    
    def storage_mode(sym)
      @storage = sym
    end
    
    protected
    def in_memory?
      storage == :memory
    end
    
    def in_file?
      storage == :file
    end
  end
end