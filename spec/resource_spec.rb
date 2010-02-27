require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Stone::Resource do
  before(:all) do
    Stone.setup! do |stone|
      stone.db = File.expand_path(File.dirname(__FILE__) + '/db')
    end
    
    class Car
      include Stone::Resource
      storage_mode :memory

      field :year
      field :name
      validate :name do |name|
        name.is_a? String
        !name.nil?
      end
      
      field :color
      validate :color do |color|
        color.is_a? String
        ["white", "black", "gunmetal"].include? color
      end

      # belongs to Buyer
      # belongs to Manufacturer
      # has one Package
    end

    class Manufacturer
      include Stone::Resource
      storage_mode :file
      
      field :name

      # has many Cars
      # has many Buyers, through Cars
    end

    class Buyer
      include Stone::Resource
      storage_mode :memory

      field :first_name      
      field :last_name

      # has many Cars
      # has many Manufacturers, through Cars
    end

    class Package
      include Stone::Resource
      storage_mode :file

      field :leather_interior
      field :wheel_type
      field :has_spoiler
    end
  end
  
  it "should define methods from fields properly" do
    Car.method_defined?(:year).should be_true
    Car.method_defined?(:color).should be_true
    Package.method_defined?(:has_spoiler).should be_true
  end
  
  it "should initialize a Resource correctly" do
    Car.new.year.should be_nil
    Car.new(:year => 1984).year.should equal(1984)
  end
  
  it "should be valid if it meets all validations" do
    Car.new(:year => 1984, :color => "white", :name => "Taurus").should be_valid
    Car.new(:year => 1984, :color => "blue").should_not be_valid
  end
  
  it "should properly serialize a save or create" do
    car = Car.new(:year => 1984, :color => "white", :name => "Taurus")
    car.save.should be_true
    
    YAML.load_file("#{Stone.db}/Car/1.yml").color.should match("white")
  end
  
  after(:all) do
    Stone.teardown!
  end
end