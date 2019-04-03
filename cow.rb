#!/usr/bin/env ruby

require 'rubygems'
require 'RMagick'

module Cow

  CHR = '\N{U+2584}'

  def usage
    STDERR.puts "Please provide an image file, or multiple."
    exit 1
  end

  def set_color(bg, fg)
    print "\\x1b[48;5;#{bg};38;5;#{fg}m"
  end

  def reset
    print "\\x1b[0m"
  end

  def get_color(c)

    return get_grayscale(0) if c.opacity > 0x8000
    if c.red == c.green && c.red == c.blue
      return get_grayscale(baseline(c.red, 23))
    end

    r = baseline c.red
    g = baseline c.green
    b = baseline c.blue

    16 + (r * 36) + (g * 6) + b
  end

  def get_grayscale(c)
    return 0 if c == 0
    return 15 if c == 23
    231 + c
  end

  def baseline(c, b = 5)
    ((c / 65535.0) * b).round
  end

  def output_image(img)

    #		img.resize_to_fit! 96

    cols = img.columns
    rows = img.rows

    y = 0

    while y < rows
      0.upto(cols - 1) do |x|

        bg = get_color(img.pixel_color(x, y))
        if y + 1 == rows
          fg = 0
        else
          fg = get_color(img.pixel_color(x, y + 1))
        end
        set_color(bg, fg)
        print CHR

      end
      y += 2
      reset
      puts
    end	
  end
end

if $0 == __FILE__
  include Cow
  file = ARGV[0] || usage
  for file in ARGV


    #puts file

    img = Magick::Image.read(file).first

    puts "$the_cow =<<EOC;
   $thoughts
    $thoughts
     $thoughts
      $thoughts"
    puts
    output_image(img)
    puts "EOC"
  end
