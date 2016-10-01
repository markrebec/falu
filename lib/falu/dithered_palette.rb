module Falu
  class DitheredPalette < ImagePalette

    delegate :colors, to: :configuration

    def initialize(image, swatches=nil, **opts)
      configuration.configure({colors: 20})
      super(image, swatches, **opts)
    end

    def swatches
      if @swatches.empty?
        @swatches = image.dither(colors, scale: (colors*10), unique: true).sample(0, 0, size: 10, sample: true).map { |swatch| Falu::Swatch.new(swatch[0], 0) }
        image.dither(colors, scale: scale).sample(0, 0, size: size, sample: sample).each do |clr|
          color = Falu::Color.new(clr[0])
          exact = @swatches.index { |s| s.color.hex.to_s == color.hex.to_s }
          unless exact.nil?
            @swatches[exact] += clr[1]
            next
          end

          @swatches.sort { |a,b| b.count <=> a.count }.each_with_index do |swatch, s|
            if [:red, :green, :blue].all? { |c| (swatch.color.rgb.send(c) - color.rgb.send(c)).abs <= 10 }
              @swatches[s] += clr[1]
              break
            end
          end
        end
      end
      @swatches
    end

    def as_json(options={})
      super(options).merge({
        colors: colors
      })
    end
  end
end
