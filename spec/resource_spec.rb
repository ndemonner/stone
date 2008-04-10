require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Resource do
  
  before(:all) do
    get_resources
    Stone.build_datastore(STONE_ROOT/"sandbox_for_specs", @resources)
    load_resources
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
    # Field was declared in resource as:
    # field :author, String
    
    @author.name = 3
    @author.email = "nick@cladby.com"
    @author.save.should_not be_true
  end
  
  it "should create a yaml file for each saved object" do
    @author.name = "Nick DeMonner"
    @author.email = "nick@cladby.com"
    @author.save
    File.exists?(Stone.local_dir/"authors"/"1.yml").should be_true
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
  
  it "should find and return all objects that match conditions provided" do
    @author.name = "Bob Hicklesby"
    @author.email = "bob@gmail.com"
    @author.save
    people = Author.all("name == 'Nick DeMonner' || email.include?('gmail')")
    people.size.should == 2
  end
  
  it "should find and return the first object that matches conditions provided" do
    person = Author.first("name == 'Nick DeMonner'")
    person.id.should == 1
  end
  
  it "should let .first and .all work with fields that aren't Strings" do
    @author.name = "Higglesby Wordsworth"
    @author.email = "higglebear@higgly.com"
    @author.favorite_number = 3
    @author.save
    Author.first("favorite_number == 3").should be_instance_of Author
  end
  
  it "should perform a put if the object already exists on save" do
    author = Author.first("name == 'Nick DeMonner'")
    author.email = "nick@bzzybee.com"
    author.save
    Author.get(author.id).email.should == "nick@bzzybee.com" 
  end
  
  it "should delete an object and it's yaml file upon Resource.delete" do
    author = Author.first("favorite_number == 3")
    Author.delete(author.id).should be_true
  end
  
  it "should execute Resource callbacks" do
    @author.name = "ben hurr"
    @author.email = "chariot_guy@hotmail.com"
    @author.save
    @author.name.should == "Ben Hurr"
  end
end