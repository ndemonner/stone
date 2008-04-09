# test
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
      
      def included(base)
        base.send(:extend, self)
        base.send(:include, ::Validatable)
        
        unless base.to_s.downcase == "spec::example::examplegroup::subclass_1"
          base.class_eval <<-EOS, __FILE__, __LINE__
            def initialize
              self.id = self.next_id_for_klass(self.class)
            end
          EOS
        end
        
        rsrc_sym = base.to_s.downcase.to_sym
        @@map ||= AssociationMap.new
        @@store ||= DataStore.new
        unless @@store.resources.include? rsrc_sym
          @@store.resources[rsrc_sym] = DataStore.load_data(rsrc_sym)
        end
      end
    end # self
    
    @@fields = {}

    def field(name, klass, *opts)
      klass_sym = self.to_s.downcase.to_sym
      unless @@fields[klass_sym]
        @@fields[klass_sym] = [{:name => name, :klass => klass}]
      else
        @@fields[klass_sym] << {:name => name, :klass => klass}
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
    
    def id=(value)
      @id = value
    end
    
    def id
      @id
    end
    
    def before_save(meth, *opts)
    end
    
    def before_destroy(meth, *opts) 
    end
    
    def before_create(meth, *opts)
    end
    
    def after_save(meth, *opts)
    end
    
    def after_create(meth, *opts)
    end
    
    def after_destroy(meth, *opts)
    end
    
    def has_many(resource, *opts)
    end
    
    def has_one(resource, *opts)
    end
    
    def belongs_to(resource, *opts)
    end
    
    def has_and_belongs_to_many(resource, *opts)
    end
    
    def save
      return false unless self.valid?
      sym = DataStore.determine_put_or_post(self, @@store)
      self.class.send(sym, self)
    end
    
    def fields
      @@fields
    end
    
    def get(id = nil, *opts)

    end

    def get_all(*opts)

    end
    
    def delete(id)

    end
    
    def next_id_for_klass(klass)
      sym = klass.to_s.downcase.to_sym
      if @@store.resources.has_key?(sym) && !@@store.resources[sym].blank?
        return @@store.resources[sym].last[0] + 1
      else
        return 1
      end
    end

    private

    
    def post(obj)
      DataStore.write_yaml(obj)
      @@store.resources[obj.class.to_s.downcase.to_sym] << [obj.id, obj]
      true
    end

    def put(id, obj)

    end
    
    
  end # Resource
  
end # Stone