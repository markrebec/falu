require 'falu/colors/base'

module Falu
  module Colors
    class RGB < Base
      def initialize(*color)
        color = color[0] if color.length == 1
        raise "Invalid RGB Color: #{color.to_s}" unless Falu::Color.rgb?(color)
        @color = color.is_a?(Array) ? color.join(',') : color
      end

      def colors
        @colors ||= color.to_s.split(',').map { |c| c.strip.to_i }
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

      def absolute
        colors.sum
      end

      def inverse
        @inverse ||= colors.map { |c| c / 255.0 }
      end

      def chroma
        @chroma ||= (inverse.max - inverse.min)
      end

      def lightness
        @lightness ||= ((inverse.max + inverse.min) / 2)
      end

      def saturation
        @saturation ||= begin
          if inverse.max == inverse.min
            0
          else
            if lightness < 0.5
              (chroma / (inverse.max + inverse.min))
            else
              (chroma / (2 - inverse.max - inverse.min))
            end
          end
        end
      end

      def hue
        @hue ||= begin
          if inverse.max == inverse.min
            0
          else
            rd,gr,bl = *inverse

            if rd == inverse.max
              hue = ((gr - bl) / chroma % 6) * 60
            elsif gr == inverse.max
              hue = ((bl - rd) / chroma + 2) * 60
            elsif bl == inverse.max
              hue = ((rd - gr) / chroma + 4) * 60
            end
          end
        end
      end

      def to_s
        colors.map { |c| c.round.to_s.rjust(3, '0') }.join(',')
      end

      def to_a
        colors
      end

      def to_h
        {red: red, green: green, blue: blue}
      end

      def to_rgb
        self
      end

      def to_hex
        Falu::Colors::HEX.new("##{colors.map { |c| c.to_s(16).rjust(2, '0') }.join}")
      end

      def to_hsl
        Falu::Colors::HSL.new([hue, (saturation * 100), (lightness * 100)])
      end
    end
  end
end
