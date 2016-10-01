module Falu
  class ImagePalette < Palette
    delegate :sample, :scale, :size, to: :configuration

    def initialize(image, swatches=nil, **opts)
      configuration.configure({sample: nil, scale: 500, size: 10})
      super(swatches, **opts)
      @image = image
    end

    def image
      @image = Falu::Image.new(@image) unless @image.is_a?(Falu::Image)
      @image
    end

    def swatches
      @swatches = image.scale(scale).sample(0, 0, size: size, sample: sample).map { |swatch| Falu::Swatch.new(*swatch) } if @swatches.empty?
      @swatches
    end
  end
end
