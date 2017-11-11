require 'tempfile'

# TODO currently this relies on shelling out to imagemagick via minimagick, but could be improved
#
# Image
# Images::
#   Image
#   Original
#   Dithered
#   Scaled

module Falu
  class Image

    delegate :width, :height, :path, :run_command, to: :image

    def initialize(image)
      @raw_image = image
      @image = image
    end

    def image
      @image = MiniMagick::Image.open(@image) unless @image.is_a?(MiniMagick::Image)
      @image
    end

    def histogram
      #hist = run_command("convert", "#{path}", "-format", "%c", "histogram:info:").split("\n")
      #return hist.first
      run_command("convert", "#{path}", "-format", "%c", "histogram:info:").split("\n").map do |clr|
        next unless match = clr.match(/\s*(\d+):\s+\((\d+,\d+,\d+)\)\s+(#[\da-fA-F]{6})\s+(.*)/)
        color = {
          count: match[1].to_i,
          rgb: match[2],
          hex: match[3].downcase
        }

        if block_given?
          yield(*(color.values + [color]))
        else
          color
        end
      end.compact.to_enum
    end

    def pixels(x=0, y=0, w=nil, h=nil, size: 10, sample: nil, &block)
      w ||= width
      h ||= height

      (w / size).times.map do |ww|
        pw = (ww * size)
        px = x + pw

        (h / size).times.map do |hh|
          ph = (hh * size)
          py = y + ph

          pixels = run_command("convert", "#{path}[#{size}x#{size}+#{px}+#{py}]", "-depth", '8', "txt:").split("\n")
          sample = 1 if sample == true
          pixels = pixels.sample(sample) if sample

          pixels.map do |pxl|
            next unless match = pxl.match(/(\d+),(\d+):\s+\((\d+,\d+,\d+)\)\s+(#[\da-fA-F]{6})\s+(.*)/)

            pixel = {
              x: match[1].to_i + pw,
              y: match[2].to_i + ph,
              rgb: match[3],
              hex: match[4].downcase,
            }

            if block_given?
              yield(*(pixel.values + [pixel]))
            else
              pixel
            end
          end
        end
      end.flatten.to_enum
    end

    def sample(x=0, y=0, w=nil, h=nil, size: 10, sample: false, &block)
      palette = {}
      pixels(x, y, w, h, size: size, sample: sample) do |x,y,rgb,hex|
        palette[hex] ||= 0
        palette[hex] += 1
        yield(hex) if block_given?
      end
      palette.to_a.to_enum
    end

    def miro
      colors = Miro::DominantColors.new(@raw_image)
      hex = colors.to_hex
      pct = colors.by_percentage
      hex.each_with_index.map do |clr,idx|
        [clr, pct[idx] * 100]
      end
    end

    def scale(scale, filename: nil)
      filename ||= Tempfile.new(['scaled', '.png']).path

      args = [
        'convert', path,
        '-scale', scale,
        filename
      ]

      run_command(*args)
      self.class.new(filename)
    end

    def dither(colors=3, filename: nil, scale: nil, unique: false)
      filename ||= Tempfile.new(['dithered', '.png']).path
      scale ||= unique ? (colors * 10) : [width, height].max 

      args = [
        'convert', path,
        '+dither',
        '-colors', colors,
        (unique ? '-unique-colors' : nil),
        '-scale', scale,
        filename
      ].compact

      run_command(*args)
      self.class.new(filename)
    end
  end
end
