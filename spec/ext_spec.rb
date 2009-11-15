require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Fixnum do
  it "should report if it sits between a range" do
    7.is_between(2..10).should be_true
  end
end