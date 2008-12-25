require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Resource do
  before(:all) do
    get_resources
    FileUtils.mkdir_p Dir.pwd/"sandbox_for_specs"/"datastore"/"posts"
    (1..170).each do |i|
      File.open(Dir.pwd/"sandbox_for_specs"/"datastore"/"posts"/"#{i}.yml","w") do |f|
        f << <<-YAML
--- !ruby/object:Post 
created_at: 2008-11-28T01:40:28+01:00
title: Test
errors: !ruby/object:Validatable::Errors 
  errors: {}
id: #{i}
body: Test
        YAML
      end
    end
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)
  end
  after(:all) do
    Stone.empty_datastore
  end
  it "should work with sets of more than 100 resources" do
    new_post = Post.new(:title => "Test", :body => "Test")
    new_post.id.should == 171
    (1..171).each do |i|
      Post.delete(i)
    end
  end
end