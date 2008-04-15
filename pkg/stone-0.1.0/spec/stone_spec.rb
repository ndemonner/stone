require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone do
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end
  
  it "should create a new, blank datastore at a given path" do
    File.exists?(STONE_ROOT/"sandbox_for_specs"/"datastore").should be_true
  end
end