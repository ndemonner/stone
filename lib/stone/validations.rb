module Stone
  module Validations
    def self.extended(base)
      base.extend(ClassMethods)
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :vals
      
      def validations
        self.vals = []
        yield
      end
      
      def present(*params)
      end
      
      def unique(*params)
      end
      
      def length(*params)
      end
      
      def formatted(*params)
      end
    end
  end
end