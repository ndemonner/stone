require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Query do
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end

  it "should craft a correct Query when initialized" do
    q = Stone::Query.new("email", :lt)
    q.field.should == "email"
    q.op.should == ".<"
  end

  it "should craft a proper expression for a given argument" do
    q = Stone::Query.new("email", :not)
    q.expression_for("nick@cladby.com").should == "email.!=('nick@cladby.com')"
  end
end