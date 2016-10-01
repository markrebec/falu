require 'falu/colors/hex'
require 'falu/colors/rgb'
require 'falu/colors/hsl'

module Falu
  class Color
    attr_reader :color

    class << self
      def dump(color)
        color.as_json
      end

      def load(json)
        new(json.values.first)
      end

      def color(color)
        if hex?(color)
          Falu::Colors::HEX.new(color)
        elsif rgb?(color) && !hsl?(color)
          Falu::Colors::RGB.new(color)
        elsif hsl?(color) && !rgb?(color)
          Falu::Colors::HSL.new(color)
        else
          raise "Unable to determine color type (RGB vs HSL): #{color.to_s}"
        end
      end

      def hex?(color)
        color = color.join('') if color.is_a?(Array)
        !!color.to_s.match(/#?([\da-fA-F]{2})([\da-fA-F]{2})([\da-fA-F]{2})/)
      end

      def rgb?(color)
        color = color.to_s.split(',') unless color.is_a?(Array)
        color = color.map { |c| c.to_i }
        return false if color.length != 3
        return false if color.any? { |c| c > 255 || c < 0 }
        true
      end

      def hsl?(color)
        color = color.to_s.split(',') unless color.is_a?(Array)
        color = color.map { |c| c.to_f }
        return false if color.length != 3
        return false if color[0] > 360 || color[0] < 0
        return false if color[1..2].any? { |c| c > 100 || c < 0 }
        true
      end
    end

    def initialize(color)
      @color = color.is_a?(Falu::Colors::Base) ? color : self.class.color(color)
    end

    def hex
      @hex ||= color.to_hex
    end

    def rgb
      @rgb ||= color.to_rgb
    end

    def hsl
      @hsl ||= color.to_hsl
    end

    def <=>(other)
      rgb.absolute <=> other.rgb.absolute
    end

    def to_s(stype=:hex)
      send(stype).to_s
    end

    def as_json(options={})
      # TODO options to control what type to return
      hex.as_json
    end
  end
end
