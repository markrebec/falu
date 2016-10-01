require 'canfig'
require 'active_support/core_ext/module'
require 'active_support/core_ext/object/json'
require 'mini_magick'
require 'falu/image'
require 'falu/color'
require 'falu/swatch'
require 'falu/palette'
require 'falu/image_palette'

module Falu

  def self.colors
    @colors ||= File.read(File.expand_path('../../colors.txt', __FILE__)).split("\n").map do |c|
      carr = c.split("|")
      {name: carr[0], hex: carr[1], rgb: carr[2], hsl: carr[3]}
    end
  end
end
