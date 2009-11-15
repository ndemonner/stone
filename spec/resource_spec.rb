require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Stone::Resource do
  before(:all) do
    Stone.setup! do |stone|
      stone.db = File.expand_path(File.dirname(__FILE__) + '/db')
    end
    
    class Car
      include Stone::Resource

      field :year
      field :name
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

      field :name

      # has many Cars
      # has many Buyers, through Cars
    end

    class Buyer
      include Stone::Resource

      field :first_name      
      field :last_name

      # has many Cars
      # has many Manufacturers, through Cars
    end

    class Package
      include Stone::Resource

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
  
  after(:all) do
    Stone.teardown!
  end
end