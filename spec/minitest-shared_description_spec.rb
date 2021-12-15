ENV['MT_NO_PLUGINS'] = '1' # Work around stupid autoloading of plugins
require 'minitest/autorun'
require 'minitest/shared_description'

describe "minitest/shared_description" do
  def run_runnables(runnables)
    runnables.each do |runnable|
      runnable.runnable_methods.each do |method_name|
        Minitest.run_one_method(runnable, method_name)
      end
    end
  end

  before do
    @runnables = self.class.runnables.dup
  end

  it "should handle standard spec inclusion" do
    runs = []

    x = shared_description do
      before{(@order ||= []) << :bx}
      after{@order << :ax; runs << [self.class.name, @order]}
      it("x"){@order << :x}
    end

    describe "z" do
      before{(@order ||= []) << :bz}
      after{@order << :az}
      it("z"){@order << :z}
      include x
    end

    new_runnables = self.class.runnables.dup - @runnables
    assert_equal %w'z', new_runnables.map(&:name)

    run_runnables(new_runnables)
    assert_equal [["z", [:bx, :bz, :x, :az, :ax]], ["z", [:bx, :bz, :z, :az, :ax]]], runs.sort_by{|a| a.flatten.map(&:to_s)}
  end

  it "should handle describe under shared_description" do
    runs = []

    x = shared_description do
      describe "x" do
        before{@order << :bx}
        after{@order << :ax}
        it("x"){@order << :x}
      end
    end

    y = shared_description do
      include x
      describe "y" do
        include x
        before{@order << :by}
        after{@order << :ay}
        it("y"){@order << :y}
      end
    end

    describe "z" do
      before{(@order = []) << :bz}
      after{@order << :az; runs << [self.class.name, @order]}
      it("z"){@order << :z}
      include y
    end

    new_runnables = self.class.runnables.dup - @runnables
    assert_equal %w'z z::x z::y z::y::x', new_runnables.map(&:name).sort

    run_runnables(new_runnables)
    assert_equal [["z", [:bz, :z, :az]], ["z::x", [:bz, :bx, :x, :ax, :az]], ["z::y", [:bz, :by, :y, :ay, :az]], ["z::y::x", [:bz, :by, :bx, :x, :ax, :ay, :az]]], runs.sort
  end
end
