class Author #:nodoc:
  include Stone::Resource
  
  field :name, String
  field :email, String
  field :favorite_number, Fixnum
  field :created_at, DateTime

  validates_presence_of :name, :email
  
  before_save :cap_name
  
  has_many :posts
  has_many :comments
  
  def cap_name
    self.name = self.name.titlecase
  end
end