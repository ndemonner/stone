class Fixnum
  def is_between(range)
    self >= range.begin && self <= range.end
  end
end