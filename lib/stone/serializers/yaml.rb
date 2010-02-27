module Stone
  module Serializer
    class YAML
      
      def write(object)
        File.open("#{Stone.db}/#{object.class}/#{object.id}.yml", "w") do |out|
          ::YAML.dump(object, out)
        end
        true
      end
      
      def read_one(klass, id)
        ::YAML.load_file("#{Stone.db}/#{klass}/#{id}.yml")
      end
      
      def read_all(klass)
        results = []
        files = Dir.glob["#{Stone.db}/#{klass}/*.yml"]
        return false if files.empty?
        
        files.each do |file|
          results << ::YAML.load_file(file)
        end
      end
      
      def new_id(klass)
        if counter = ::YAML.load_file("#{Stone.db}/counter.yml")
          counter[klass] += 1
          File.open("#{Stone.db}/counter.yml", "w") do |out|
            ::YAML.dump(counter, out)
          end
        end
      end
      
    end
  end
end