require File.join(File.dirname(__FILE__), "spec_helper")

describe Symbol do
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end

  it "should return a correct Query when a comparison method is used" do
    :name.gt.should be_instance_of(Stone::Query)
    :name.gt.op.should == ".>"

    :name.matches.should be_instance_of(Stone::Query)
    :name.matches.op.should == ".=~"
  end
end