require 'spec_helper'

# Release the Stone rewrite when this spec passes

describe Stone do
  before(:all) do
    Stone.setup!
  end
  
  before(:each) do
    @students = [ Student.post(:first_name => "Nick", :last_name => "DeMonner", :year => 11),
                  Student.post(:first_name => "Erin", :last_name => "Ching"), :year => 9 ]
    @teachers = [ Teacher.post(:first_name => "Bob", :last_name => "Bobberson", :email => "bbobberson@coolschool.edu"),
                  Teacher.post(:first_name => "Mike", :last_name => "Michaelson"), :email => "mmichaelson@coolschool.edu" ]    
    @essays = [ Essay.post(:title => "I Love My School", :body => "I love my school because..."),
                Essay.post(:title => "Dogs Are Awesome!", :body => "I love my dog because...") ]
  end
  
  it "establishes relationships" do
    @essays[0].relate @students[0]
    @students[0].relate @teachers[0]
  end
  
  after(:all) do
    Stone.teardown!
  end
end