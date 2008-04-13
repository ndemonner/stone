require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Resource do
  
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end
  
  before(:each) do
    @author = Author.new
  end
  
  it "should extend any class in which it is included" do
    class Blah #:nodoc:
      include Stone::Resource
    end
    Blah.new.respond_to?(:field).should be_true
  end
  
  it "should be valid when validates_ methods are fulfilled" do
    @author.name = "Nick DeMonner"
    @author.email = "nick@cladby.com"
    @author.should be_valid
  end
  
  it "should be invalid when validates_ methods are not fulfilled" do
    @author.name = "Nick DeMonner"
    @author.should_not be_valid
  end
  
  it "should be invalid when a field's class does not match its declaration" do
    @author.name = 3
    @author.email = "nick@cladby.com"
    @author.save.should_not be_true
  end
  
  it "should create a yaml file for each saved object" do
    @author.name = "Nick DeMonner"
    @author.email = "nick@cladby.com"
    @author.save
    File.exists?(Stone::DataStore.local_dir/"authors"/"1.yml").should be_true
  end
  
  it "should create an object whose id is last object.id + 1" do
    @author.id.should == 2
  end
  
  it "should not save unless all validations pass" do
    @author.name = "Heyo McGee"
    @author.save.should_not be_true
  end
  
  it "should find and return an object using get" do
    @author.name = "Mike McMichaels"
    @author.email = "heyo@something.com"
    @author.save
    person = Author.get(@author.id)
    person.name.should == "Mike McMichaels"
  end
  
  it "should find and return an object using []" do
    @author.name = "Mary Poppins"
    @author.email = "weyo@something.com"
    @author.save
    person = Author[@author.id]
    person.name.should == "Mary Poppins"
  end
  
  it "should accept Resource.find(hash) form" do
    author = Author.first(:name => "Nick DeMonner")
    author.should be_instance_of(Author)
  end
  
  it "should accept be able to find an object using a regex" do
    author = Author.first(:name.matches => /nick/i)
    author.should be_instance_of(Author)
  end
  
  it "should raise an exception anything other than a Hash is provided for find" do
    lambda {Author.first("Nick")}.should raise_error
  end
  
  it "should find and return all objects that match conditions provided" do
    @author.name = "Nick Hicklesby"
    @author.email = "nick@gmail.com"
    @author.save
    people = Author.all(:name.includes => "Nick")
    people.size.should == 2
  end
  
  it "should find and return the first object that matches conditions provided" do
    person = Author.first(:name.equals => 'Nick DeMonner')
    person.id.should == 1
  end
  
  it "should let .first and .all work with fields that aren't Strings" do
    @author.name = "Higglesby Wordsworth"
    @author.email = "higglebear@higgly.com"
    @author.favorite_number = 3
    @author.save
    Author.first(:favorite_number.equals => 3).should be_instance_of(Author)
  end
  
  it "should perform a put if the object already exists on save" do
    author = Author.first(:name.equals => 'Nick DeMonner')
    author.email = "nick@bzzybee.com"
    author.save
    Author.get(author.id).email.should == "nick@bzzybee.com" 
  end
  
  it "should delete an object and it's yaml file upon Resource.delete" do
    author = Author.first(:favorite_number.equals => 3)
    Author.delete(author.id).should be_true
  end
  
  it "should execute Resource callbacks" do
    @author.name = "ben hurr"
    @author.email = "chariot_guy@hotmail.com"
    @author.save
    @author.name.should == "Ben Hurr"
  end
  
  it "should not save if there is a duplicate and the field is unique" do
    @author.name = "John Doe"
    @author.email = "nick@bzzybee.com"
    @author.save.should_not be_true
  end
  
  it "should retrieve a parent object if belongs_to has been set" do
    @post = Post.new
    @post.title = "Stone is Cool"
    @post.body = "Stone is cool because..."
    author = Author.first(:name.equals => 'Nick DeMonner')
    @post.author_id = author.id
    @post.save
    @post.author.should be_instance_of(Author)
  end
  
  it "should retrieve children objects id has_many has been set" do
    @post = Post.new
    @post.title = "Stone is Awesome"
    @post.body = "Stone is awesome because..."
    author = Author.first(:name.equals => 'Nick DeMonner')
    @post.author_id = author.id
    @post.save
    author.posts.size.should == 2
  end
  
  it "should accept Resource.new(hash) form" do
    @author = Author.new(:name => "Ron DeMonner", :email => "ron@cladby.com")
    @author.should be_valid
  end
  
  it "should accept Resource.new(params[:resource]) form" do
    params = {}
    params[:author] = {:name => "Ron DeMonner", :email => "ron@cladby.com"}
    @author = Author.new(params[:author])
    @author.should be_valid
  end
  
  it "should accept Resource.update_attributes(hash)" do
    params = {}
    params[:author] = {:name => "Ron DeMonner", :email => "ron@cladby.com"}
    
    plain_hash = {:name => "Nick DeMonner", :email => "nick@cladby.com"}
    
    author = Author.first(:name => "Nick DeMonner")
    author.update_attributes(params[:author]).should be_true
    author.update_attributes(plain_hash).should be_true
  end

end