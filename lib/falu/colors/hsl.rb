require 'falu/colors/base'

module Falu
  module Colors
    class HSL < Base
      def initialize(*color, hex: nil, rgb: nil)
        color = color[0] if color.length == 1
        raise "Invalid HSL Color: #{color.to_s}" unless Falu::Color.hsl?(color)
        @color = color.is_a?(Array) ? color.join(',') : color
      end

      def colors
        @colors ||= color.to_s.split(',').map { |c| c.strip.to_f }
      end

      def hue
        colors[0]
      end

      def saturation
        colors[1]
      end

      def lightness
        colors[2]
      end

      def to_s
        colors.map { |c| c.round.to_s.rjust(3, '0') }.join(',')
      end

      def to_a
        colors
      end

      def to_h
        {hue: hue, saturation: saturation, lightness: lightness}
      end

      def hue_to_rgb(p, q, t)
        t += 1.0 if t < 0
        t -= 1.0 if t > 1
        return p + (q - p) * 6.0 * t if t < (1.0/6.0)
        return q if t < (1.0/2.0)
        return p + (q - p) * (2.0/3.0 - t) * 6.0 if t < (2.0/3.0)
        return p
      end

      def to_hsl
        self
      end

      def to_rgb
        red = grn = blu = lit = (lightness.to_f / 100.0)
        hue, sat = (self.hue.to_f / 360.0), (saturation.to_f / 100.0)

        if sat > 0
          lum = lit < 0.5 ? lit * (1.0 + sat) : (lit + sat) - (lit * sat)
          crm = (2.0 * lit) - lum
          red = hue_to_rgb(crm, lum, hue + 1.0/3.0)
          grn = hue_to_rgb(crm, lum, hue)
          blu = hue_to_rgb(crm, lum, hue - 1.0/3.0)
        end

        Falu::Colors::RGB.new([(red * 255).round, (grn * 255).round, (blu * 255).round])
      end

      def to_hex
        to_rgb.to_hex
      end
    end
  end
end
