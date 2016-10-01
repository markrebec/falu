module Falu
  class DitheredPalette < ImagePalette
    delegate :colors, to: :configuration

    def initialize(image, swatches=nil, **opts)
      configuration.configure({colors: 20})
      super(image, swatches, **opts)
    end

    def swatches
      @swatches = image.scale(scale).dither(colors).sample(0, 0, size: size, sample: sample).map { |swatch| Falu::Swatch.new(*swatch) } if @swatches.empty?
      @swatches
    end
  end
end
