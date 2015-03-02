module TestHelpers
  module RSpecMatchers
    def be_a_nonempty(klass)
      BeANonempty.new(klass)
    end

    class BeANonempty
      def initialize(klass)
        @klass = klass
      end

      def matches?(object)
        object.is_a?(@klass) && !object.empty?
      end
    end
  end
end
