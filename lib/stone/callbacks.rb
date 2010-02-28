module Stone
  module Callbacks
    def self.extended(base)
      base.extend(ClassMethods)
    end
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      attr_accessor :cbacks
      
      def callbacks
        self.cbacks = []
        yield
      end
      
      def on_post(*params)
      end
      
      def on_put(*params)
      end
      
      def on_get(*params)
      end
      
      def on_delete(*params)
      end
    end
  end
end