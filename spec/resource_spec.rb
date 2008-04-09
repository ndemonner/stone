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
end