module Falu
  class Swatch
    attr_reader :color, :count
    class << self
      def dump(swatch)
        swatch.as_json
      end

      def load(json)
        json.symbolize_keys!
        new(json[:color].values.first, json[:count])
      end
    end

    def initialize(color, count=0)
      @color = color.is_a?(Falu::Color) ? color : Falu::Color.new(color)
      @count = count.to_i
    end

    def <=>(other)
      if count == other.count
        color <=> color
      else
        count <=> other.count
      end
    end

    def ==(other)
      to_s == other.to_s
    end

    def +(cnt)
      self.class.new(color, (count + cnt.to_i))
    end

    def -(cnt)
      self.class.new(color, (count - cnt.to_i))
    end

    def to_i
      count
    end

    def to_s
      color.to_s
    end

    def to_a
      [to_s, to_i]
    end

    def to_h
      {color: to_s, count: to_i}
    end

    def as_json(options={})
      #{color: color.as_json, count: count}
      to_a
    end
  end
end
