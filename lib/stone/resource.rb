module Stone
  
  # Adds the ability to persist any class it is included in
  # === Example
  #
  # class Post
  #   include Stone::Resource
  #   
  #   field :body, String
  # end
  #
  module Resource
    
    class << self
    end # self

    def self.included(base)
      base.send(:extend, self)
      base.send(:include, ::Validatable)
    end
    
    @@fields = {}

    def field(name, klass, *opts)
      unless @@fields[self.to_s.downcase.to_sym]
        @@fields[self.to_s.downcase.to_sym] = [{:name => name, :klass => klass}]
      else
        @@fields[self.to_s.downcase.to_sym] << {:name => name, :klass => klass}
      end
      
      name = name.to_s
      
      self.class_eval <<-EOS, __FILE__, __LINE__
        def #{name}
          @#{name}
        end
        
        def #{name}=(value)
          @#{name} = value
        end
      EOS

    end
    
    def before_save(meth, *opts)
    
    end
    
    def has_many(resource)
    
    end
    
    def has_one(resource)
    
    end
    
    def belongs_to(resource)
      
    end
    
    def save
      
    end
    
    def fields
      @@fields
    end
    
  end # Resource
  
end # Stone