require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Callbacks do
  before(:all) do
    get_resources
    Stone.start(STONE_ROOT/"sandbox_for_specs", @resources)

    class Dude
      include Stone::Resource

      def raise_hell
        raise "Zomgz!"
      end
    end
  end

  before(:each) do
    @c = Stone::Callbacks.new
  end

  it "should register a class for callbacks" do
    @c.register_klass(Dude)
    @c.include?(:dude).should be_true
    @c[:dude].include?(:before_save).should be_true
  end

  it "should register a method to execute for a given callback" do
    @c.register_klass(Dude)
    @c.register(:before_save, :raise_hell, Dude)
    @c[:dude][:before_save].include?(:raise_hell).should be_true
  end

  it "should fire the correct method when a callback is executed" do
    # had to define say_hello to raise an error because fire() always
    # returns true

    @c.register_klass(Dude)
    @c.register(:before_save, :raise_hell, Dude)

    # raises "Zomgz!"
    Dude.class_eval {fire(:before_save)}.should raise_error
  end
end