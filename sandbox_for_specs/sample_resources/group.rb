class Group
  include Stone::Resource
  
  field :name, String
  field :authors, Array
  
  has_and_belongs_to_many :authors
  
end