module Falu
  class ImagePalette < Palette
    class << self
      def dump(palette)
        palette.as_json
      end

      def load(json)
        return if json.nil?
        json.symbolize_keys!
        new(json.delete(:image), json.delete(:swatches), **json)
      end
    end

    delegate :sample, :scale, :size, :method, to: :configuration

    def initialize(image, swatches=nil, **opts)
      configuration.configure({sample: nil, scale: 500, size: 10, method: :sample})
      super(swatches, **opts)
      @image = image
    end

    def image
      @image = Falu::Image.new(@image) unless @image.is_a?(Falu::Image)
      @image
    end

    def swatches
      if method == :miro
        @swatches = image.miro.map { |swatch| Falu::Swatch.new(*swatch) } if @swatches.empty?
      else
        @swatches = image.scale(scale).sample(0, 0, size: size, sample: sample).map { |swatch| Falu::Swatch.new(*swatch) } if @swatches.empty?
      end
      @swatches
    end

    def as_json(options={})
      super(options).merge({
        sample: sample,
        scale: scale,
        size: size,
        method: method
      })
    end
  end
end
