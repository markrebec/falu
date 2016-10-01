module Falu
  class Palette
    include Enumerable
    attr_reader :swatches

    class << self
      def dump(palette)
        palette.as_json
      end

      def load(json)
        return if json.nil?
        json.symbolize_keys!
        new(json.delete(:swatches), **json)
      end
    end

    def initialize(swatches=nil, primary: nil, secondary: nil, accent: nil)
      @swatches = (swatches || []).map { |swatch| swatch.is_a?(Falu::Swatch) ? swatch : Falu::Swatch.new(*swatch) }
      self.primary = primary
      self.secondary = secondary
      self.accent = accent
    end

    def each(&block)
      swatches.each(&block)
    end

    def map(&block)
      swatches.map(&block)
    end

    def sum(*args, &block)
      swatches.sum(*args, &block)
    end

    def <<(swatch)
      swatches << (swatch.is_a?(Falu::Swatch) ? swatch : Falu::Swatch.new(*swatch))
    end

    def reverse!
      swatches.reverse!
      self
    end

    def sort!(*args, &block)
      if args.empty? && !block_given?
        swatches.sort_by!(&:count).reverse!
      else
        swatches.sort!(*args, &block)
      end
      self
    end

    def sort_by!(*args, &block)
      if args.empty? && !block_given?
        swatches.sort_by!(&:count).reverse!
      else
        swatches.sort_by!(*args, &block)
      end
      self
    end

    def lightest(*args)
      swatches.sort_by { |swatch| swatch.color.hsl.lightness }.reverse.first(*args)
    end

    def darkest(*args)
      swatches.sort_by { |swatch| swatch.color.hsl.lightness }.first(*args)
    end

    def reds(*args)
      #swatches.sort_by { |swatch| swatch.color.rgb.red }.reverse.first(*args)
      swatches.sort do |a,b|
        ared = a.color.rgb.red - (a.color.rgb.blue + a.color.rgb.green)
        bred = b.color.rgb.red - (b.color.rgb.blue + b.color.rgb.green)

        ared <=> bred
      end.first(*args)
    end

    def greens(*args)
      #swatches.sort_by { |swatch| swatch.color.rgb.green }.reverse.first(*args)
      swatches.sort do |a,b|
        agrn = a.color.rgb.green - (a.color.rgb.blue + a.color.rgb.red)
        bgrn = b.color.rgb.green - (b.color.rgb.blue + b.color.rgb.red)

        agrn <=> bgrn
      end.first(*args)
    end

    def blues(*args)
      #swatches.sort_by { |swatch| swatch.color.rgb.blue }.reverse.first(*args)
      swatches.sort do |a,b|
        ablu = a.color.rgb.blue - (a.color.rgb.red + a.color.rgb.green)
        bblu = b.color.rgb.blue - (b.color.rgb.red + b.color.rgb.green)

        ablu <=> bblu
      end.first(*args)
    end

    def dominant(*args)
      swatches.sort_by(&:count).reverse.first(*args)
    end

    def primary=(pri)
      # TODO check that the color exists in the palette
      @primary = pri
    end

    def primary
      @primary ||= dominant
    end

    def secondary=(sec)
      # TODO check that the color exists in the palette
      @secondary = sec
    end

    def secondary
      @secondary ||= dominant(2).last
    end

    def accent=(acc)
      # TODO check that the color exists in the palette
      @accent = acc
    end

    def accent
      @accent ||= dominant(3).last
    end

    def as_json(options={})
      { primary: primary.to_s,
        secondary: secondary.to_s,
        accent: accent.to_s,
        swatches: swatches.as_json }
    end
  end
end
