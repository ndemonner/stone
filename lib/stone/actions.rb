module Stone
  module Actions
    def self.extended(base)
      base.extend(ClassMethods)
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def get(key)
        ::Stone.serializer.get(key)
      end
      
      def post(attrs)
        ::Stone.serializer.post(attrs)
      end
      
      def delete(key)
        ::Stone.serializer.delete(key)
      end
    end 
  end
end