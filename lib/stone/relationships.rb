module Stone
  module Relationships
    def self.extended(base)
      base.extend(ClassMethods)
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :rels, :deps
      
      def relationships
        self.rels = []
        self.deps = []
        yield
      end
      
      def relate(klass)
        self.rels << klass
      end
      
      def depends_on(klass)
        self.deps << klass
      end
    end
    
    def relate(item)
      
    end
  end
end