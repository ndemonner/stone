class Person
  include Stone::Resource
  
  field :name, String
  has_many :comments
end