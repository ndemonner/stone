class String #:nodoc:
  def /(o)
    File.join(self, o.to_s)
  end
  def make_key
    self.downcase.to_sym
  end
  # From Ruby Facets
  def titlecase
    gsub(/\b\w/){$&.upcase}
  end
end