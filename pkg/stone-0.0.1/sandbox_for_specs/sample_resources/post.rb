class Post
  include Stone::Resource
  
  field :title, String
  field :body, String
  
  belongs_to :author
  has_many :comments
end