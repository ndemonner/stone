class Post
  include Stone::Resource

  field :title, String
  field :body, String
  field :created_at, DateTime
  field :updated_at, DateTime

  belongs_to :author
  has_many :comments
end