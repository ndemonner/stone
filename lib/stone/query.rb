module Stone
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
                    ".~="
                  when :equals
                    ".=="
                  end
    end
    
    def expression_for(arg)
      unless arg.is_a? String
        "#{self.field}#{self.op}(#{arg})"
      else
        "#{self.field}#{self.op}('#{arg}')"
      end
    end
  end 
end