module Stone
  # Represents a single query condition
  class Query
    
    attr_accessor :field, :op
    
    def initialize(field,op)
      self.field = field
      self.op = case op
                  when :gt
                    ".>"
                  when :lt
                    ".<"
                  when :gte
                    ".>="
                  when :lte
                    ".<="
                  when :includes
                    ".include?"
                  when :matches
                    ".=~"
                  when :equals
                    ".=="
                  when :not
                    ".!="
                  end
    end
    
    # Builds an expression from the conditions given during first or all
    # === Parameters
    # +arg+:: Some conditional argument
    def expression_for(arg)
      if arg.is_a? String
        "#{self.field}#{self.op}('#{arg}')"
      elsif arg.is_a? Regexp
        "#{self.field}#{self.op}(#{arg.inspect})"
      elsif arg.is_a? Date
        "#{self.field}#{self.op}(DateTime.parse(\"#{arg}\"))"
      else
        "#{self.field}#{self.op}(#{arg})"        
      end
    end
  end 
end