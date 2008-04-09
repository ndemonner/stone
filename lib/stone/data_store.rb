module Stone
  # An in-memory representation of the file-based datastore
  class DataStore
    
    class << self
      # Loads yaml files specific to the resource represented by +sym+
      # === Parameters
      # +sym+::
      #   Symbol representing resource data to load
      def load_data(sym)
        dir = Stone.local_dir
        ymls = Dir.glob(dir/sym.to_s.pluralize/"*.yml")
        objs = []
        unless ymls.empty?
          ymls.each do |yml|
            obj = YAML.load_file yml
            objs << [obj.id, obj]
          end
        end
        return objs
      end
      
      # If the object already exists (id was found),
      # this returns +put+(update), else +post+(create)
      # === Parameters
      # +obj+::
      #   The instantiated resource to be saved
      # +store+:: 
      #   DataStore object
      def determine_put_or_post(obj, store)
        store.resources[obj.class.to_s.downcase.to_sym].each do |o|
          return :put if o[0] == obj.id
        end
        return :post
      end
      
      def write_yaml(obj)
        path = Stone.local_dir/obj.class.to_s.downcase.pluralize/"#{obj.id}.yml"
        File.open(path, 'w') do |out|
          YAML.dump(obj, out)
        end
      end
    end # self
    
    def initialize
      @resources = {}
    end
    
    def resources
      @resources
    end
    
  end # DataStore
end # Stone