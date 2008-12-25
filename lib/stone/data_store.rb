module Stone
  # An in-memory representation of the file-based datastore
  class DataStore
    
    class << self
      attr_accessor :local_dir

      # Loads yaml files specific to the resource represented by +sym+
      # === Parameters
      # +sym+::
      #   Symbol representing resource data to load
      def load_data(sym)
        ymls = Dir.glob(self.local_dir/sym.to_s.pluralize/"*.yml").sort { |a,b| File.basename(a,".yml").to_i - File.basename(b,".yml").to_i }
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
      def determine_save_method(obj, store)
        store.resources[obj.model].each do |o|
          return :put if o[0] == obj.id
        end
        :post
      end
      
      # Persist the object via YAML
      # === Parameters
      # +obj+:: The object to be persisted
      def write_yaml(obj)
        path = self.local_dir/obj.models/"#{obj.id}.yml"
        File.open(path, 'w') do |out|
          YAML.dump(obj, out)
        end
      end
      
      # Removes object's yaml file
      # === Parameters
      # +id+:: id of the object to be removed
      # +klass_dir+:: directory in which object resides
      def delete(id, klass_dir)
        raise "Object could not be found" \
          unless File.exists?(self.local_dir/klass_dir/"#{id}.yml")
            
        FileUtils.remove_file(self.local_dir/klass_dir/"#{id}.yml")
        true
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