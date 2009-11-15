require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Stone do
  before(:all) do
    Stone.setup! do |stone|
      stone.db = File.expand_path(File.dirname(__FILE__) + '/db')
    end
  end
  
  it "should setup correctly" do
    Stone.map.should_not be_nil
    Stone.db.should_not be_nil
    Stone.compatibility.should be_empty
    Stone.db.should exist
  end
  
  after(:all) do
    Stone.teardown!
  end
end