module Falu
  class ImagePalette < Palette
    attr_reader :colors, :sample, :scale, :size

    def initialize(image, swatches=nil, primary: nil, secondary: nil, accent: nil, colors: 20, sample: nil, scale: 500, size: 10)
      super(swatches, primary: primary, secondary: secondary, accent: accent) unless swatches.nil?
      @image = image
      @colors = colors
      @sample = sample
      @scale = scale
      @size = size
    end

    def image
      @image = Falu::Image.new(@image) unless @image.is_a?(Falu::Image)
      @image
    end

    def swatches
      @swatches ||= image.scale(scale).dither(colors).sample(0, 0, size: size, sample: sample).map { |swatch| Falu::Swatch.new(*swatch) }
    end
  end
end
