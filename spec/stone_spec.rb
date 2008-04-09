require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone do
  before(:all) do
    get_resources
    Stone.build_datastore(STONE_ROOT/"sandbox_for_specs", @resources)
    load_resources
  end
  
  it "should create a new, blank datastore at a given path" do
    File.exists?(STONE_ROOT/"sandbox_for_specs"/"datastore").should be_true
  end
  
  it "should create an archive of an existing datastore on backup"
  it "should export an existing datastore to a given format"
  it "should import from another database and create a new datastore"
  it "should provide useful metrics about a given datastore"
end