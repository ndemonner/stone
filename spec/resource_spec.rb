require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Resource do
  
  before(:all) do
    load_resources
    empty_sandbox_data
    Stone.build_datastore(STONE_ROOT/"sandbox_for_specs", @resources)
  end
  
  before(:each) do
    @author = Author.new
  end
  
  it "should extend any class in which it is included" do
    class Blah
      include Stone::Resource
    end
    Blah.new.respond_to?(:field).should be_true
  end
  
  it "should create a yaml file for each saved object" do
    @author.name = "Nick DeMonner"
    @author.email = "nick@cladby.com"
    
    @author.save.should be_true
  end
  
  it "should create a datastore on save if one does not exist"
  it "should add to existing datastore if one exists"
  it "should save according to class name"
  it "should save in YAML"
  it "should not save unless all validations pass"
end