module Falu
  module Colors
    class Base
      attr_reader :color

      def as_json(options={})
        to_s
      end
    end
  end
end
