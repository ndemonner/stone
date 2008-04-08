module Stone
  
  # Provides a bunch of utilities for manipulating and examining data
  class Utilities
    
    class << self
      
      # Creates an archive of the datastore at +from_path+ and puts it
      # in +to_path+ (or +from_path+ if +to_path+ is not provided)
      # === Parameters
      # from_path<String>:: 
      #  The path to the existing data (either to a dir or file)
      # to_path<String>:: The format of the existing data
      def backup(from_path, to_path = nil)
        
      end
      
      # Imports data from another database to create a new Stone 
      # datastore from the imported data.
      # === Parameters
      # path<String>:: The path to the existing data (either to a dir or file)
      # format<Symbol>:: The format of the existing data
      # === Options for +format+
      # +sql+:: SQL
      # +yaml+:: YAML
      # +csv+:: CSV
      def import(path, format)
        
      end
      
      # Exports data from an existing Stone datastore to a file of the given
      # +format+
      # === Parameters
      # path<String>:: The path to the existing datastore root dir
      # format<Symbol>:: The format of the outputted data
      # === Options for +format+
      # +sql+:: SQL
      # +yaml+:: YAML
      # +csv+:: CSV
      def export(path, format)
        
      end
      
      # Provides a bunch of useful metrics about a given Stone datastore
      # === Parameters
      # path<String>:: Location of Stone datastore root dir
      def metrics_for(path)
        
      end
    end # self
    
  end # Utilities
end # Stone
