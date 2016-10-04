module Falu
  class Palette
    include Canfig::Instance
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

    def initialize(swatches=nil, **opts)
      @swatches = (swatches || []).map { |swatch| swatch.is_a?(Falu::Swatch) ? swatch : Falu::Swatch.new(*swatch) }

      configuration.configure(opts.slice!(:primary, :secondary, :accent))

      self.primary = opts[:primary]
      self.secondary = opts[:secondary]
      self.accent = opts[:accent]
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
      if pri.nil?
        @primary = pri
      else
        @primary = pri.is_a?(Falu::Swatch) ? pri : Falu::Swatch.new(pri)
      end
    end

    def primary
      @primary ||= dominant#(3).sort_by { |swtch| swtch.color.rgb.colors.sum }.first
    end

    def secondary=(sec)
      # TODO check that the color exists in the palette
      if sec.nil?
        @secondary = sec
      else
        @secondary = sec.is_a?(Falu::Swatch) ? sec : Falu::Swatch.new(sec)
      end
    end

    def secondary
      @secondary ||= begin
        dominant(3).sort_by { |swtch| (swtch.color.hsl.lightness - primary.color.hsl.lightness).abs }.last
      end
    end

    def accent=(acc)
      # TODO check that the color exists in the palette
      if acc.nil?
        @accent = acc
      else
        @accent = acc.is_a?(Falu::Swatch) ? acc : Falu::Swatch.new(acc)
      end
    end

    def accent
      @accent ||= begin
        #dominant(5).select { |swtch| ![primary.color.to_s, secondary.color.to_s].include?(swtch.color.to_s) }.sort_by { |swtch| (swtch.color.hsl.lightness - primary.color.hsl.lightness).abs + (swtch.color.hsl.lightness - secondary.color.hsl.lightness).abs }.last
        dominant(3).find { |swtch| ![primary.color.to_s, secondary.color.to_s].include?(swtch.color.to_s) }
      end
    end

    def as_json(options={})
      { primary: primary.to_s,
        secondary: secondary.to_s,
        accent: accent.to_s,
        swatches: swatches.as_json }
    end
  end
end
