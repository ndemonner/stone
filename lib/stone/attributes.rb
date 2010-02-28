require "date"

module Stone
  module Attributes
    def self.extended(base)
      base.extend(ClassMethods)
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :attrs, :rels, :deps
      
      def attributes
        self.attrs = []
        yield
      end
      
      def string(sym)
        self.attrs << [::String, sym]
      end
      
      def integer(sym)
        self.attrs << [::Integer, sym]
      end
      
      def timestamps
        self.attrs << [::DateTime, :created_at]
        self.attrs << [::DateTime, :updated_at]
      end
      
      def relationships
        self.rels = []
        yield
      end
      
      def relate(klass)
        self.rels << klass
      end
    end
  end
end