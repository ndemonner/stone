require File.join(File.dirname(__FILE__), "spec_helper")

describe String do
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end
  
  it "should correctly form paths using /" do
    ("this"/"should"/"work").should == "this/should/work"
  end
  
  it "should make a proper key given a stringified class" do
    String.to_s.make_key.should == :string
  end
end