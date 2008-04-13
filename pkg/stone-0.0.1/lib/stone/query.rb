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
                    ".=~"
                  when :equals
                    ".=="
                  end
    end
    
    def expression_for(arg)
      if arg.is_a? String
        "#{self.field}#{self.op}('#{arg}')"
      elsif arg.is_a? Regexp
        "#{self.field}#{self.op}(#{arg.inspect})"
      else
        "#{self.field}#{self.op}(#{arg})"
      end
    end
  end 
end