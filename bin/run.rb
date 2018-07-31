require_relative '../config/environment'

roberto = Actor.find(1)
natsuki = Producer.find(1)

system "clear"

prompt = TTY::Prompt.new

name = prompt.ask('What is your name?', default: ENV['USER'])

system "clear"

age_range = prompt.select("What is your age range?", %w(18-29 30-45 45+))

binding.pry

puts "HELLO WORLD"
