require 'rubygems'
require 'bundler/setup'
require File.dirname(__FILE__) + '/male_marten'
require File.dirname(__FILE__) + '/female_marten'
require 'chunky_png'
require 'progressbar'

# Profile the code

puts 'world'
world = World.import("vilas.csv") # eagle.csv
world.job_name = Time.now.to_i.to_s
# world.to_png


puts 'spawning'
  MaleMarten.spawn_population world, 100
FemaleMarten.spawn_population world, 100
world.martens.each do |marten|
  marten.age = 730
end

# RubyProf.start

ProgressBar.color_status
ProgressBar.iter_rate_mode
bar = ProgressBar.new 'ticks', 730


# Tick the world

730.times do
  world.tick
  bar.inc
  # world.to_png
}
bar.finish


# Print a flat profile to text
#
# result = RubyProf.stop
# printer = RubyProf::FlatPrinter.new(result)
# printer.print(STDOUT)
