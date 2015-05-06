require 'minitest/spec'

module Minitest::Spec::SharedDescription
  class DSL < Module
    include Minitest::Spec::DSL

    # An array of arguments and blocks to pass to describe for classes that
    # include the current module.
    attr_reader :shared_descriptions

    # Add a describe block that will be shared by all classes including the current module.
    # Example:
    #
    #   EmptyBehavior = shared_description do
    #     describe "empty" do
    #       before do
    #         @that = double
    #       end
    #
    #       it "must be empty?" do
    #         @that.must_be :empty?
    #       end
    #
    #       it "must have size equal to 0" do
    #         @that.size.must_equal 0
    #       end
    #     end
    #   end
    #
    #   describe "array" do
    #     def double; @this + @this end
    #
    #     before do
    #       @this = []
    #     end
    #
    #     include EmptyBehavior
    #   end
    #
    #   describe "hash" do
    #     def double; @this.merge(@this) end
    #
    #     before do
    #       @this = {}
    #     end
    #
    #     include EmptyBehavior
    #   end
    def describe(*desc, &block)
      (@shared_descriptions ||= []) << [desc, block]
    end

    # If including another shared description module, copy the shared
    # description class definition blocks into the receiver's.
    def include(*mods)
      mods.each do |mod|
        if mod.is_a?(DSL) && mod.shared_descriptions
          (@shared_descriptions ||= []).concat(mod.shared_descriptions)
        end
      end
      super
    end
  end

  module TestMethods
    # If including a shared description module, create subclasses using
    # each of the shared description class definition blocks.
    def include(*mods)
      mods.each do |mod|
        if mod.is_a?(DSL) && mod.shared_descriptions
          mod.shared_descriptions.each do |desc, block|
            describe(*desc, &block)
          end
        end
      end
      super
    end

    Minitest::Spec.extend(self)
  end
end

module Kernel
  # Support creating shared descriptions anywhere.
  def shared_description(&block)
    Minitest::Spec::SharedDescription::DSL.new(&block)
  end
end
