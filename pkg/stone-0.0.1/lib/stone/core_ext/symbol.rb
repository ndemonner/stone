class Symbol
  def gt
    Stone::Query.new(self.to_s, :gt)
  end
  def gte
    Stone::Query.new(self.to_s, :gte)
  end
  def lt
    Stone::Query.new(self.to_s, :lt)
  end
  def lte
    Stone::Query.new(self.to_s, :lte)
  end
  def includes
    Stone::Query.new(self.to_s, :includes)
  end
  def matches
    Stone::Query.new(self.to_s, :matches)
  end
  def equals
    Stone::Query.new(self.to_s, :equals)
  end
  def not
    Stone::Query.new(self.to_s, :not)
  end
end