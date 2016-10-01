require 'falu/colors/base'

module Falu
  module Colors
    class HEX < Base
      def initialize(*color, rgb: nil, hsl: nil)
        color = color[0] if color.length == 1
        raise "Invalid HEX Color: #{color.to_s}" unless Falu::Color.hex?(color)
        @color = color.is_a?(Array) ? color.join : color
      end

      def colors
        @colors ||= begin
          match = color.to_s.match(/#?([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})/)
          match[1..3] unless match.nil?
        end
      end

      def red
        colors[0]
      end

      def green
        colors[1]
      end

      def blue
        colors[2]
      end

      def to_s
        "##{colors.join}"
      end

      def to_a
        colors
      end

      def to_h
        {red: red, green: green, blue: blue}
      end

      def to_hex
        self
      end

      def to_rgb
        Falu::Colors::RGB.new(colors.map { |c| c.to_i(16) })
      end

      def to_hsl
        to_rgb.to_hsl
      end
    end
  end
end
