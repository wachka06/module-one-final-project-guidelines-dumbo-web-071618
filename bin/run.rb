require_relative '../config/environment'

roberto = Actor.find(1)
natsuki = Producer.find(1)

prompt = TTY::Prompt.new

system "clear"
name = prompt.ask("What is your name?")

system "clear"
gender = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

system "clear"
choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
age = prompt.multi_select("Age Range: please select all that apply.", choices)

system "clear"
race = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

system "clear"
table = Terminal::Table.new :title => name do |t|
  t << ["Gender Identity", gender]
  t << :separator
  t.add_row ["Age Range", age]
  t.add_separator
  t.add_row ["Race", race]
end

puts table

# prompt.keypress("\nPress Any Key To Continue")

prompt.select("\nOPTIONS") do |menu|
  menu.choice "Previous Record", 1
  menu.choice "Next Record", 2
  menu.choice "Main Menu", 3
end

puts "HELLO WORLD"
