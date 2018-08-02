require_relative '../config/environment'

roberto = Actor.find(1)
natsuki = Producer.find(1)

prompt = TTY::Prompt.new

system "clear"

puts "\n\nHORIZON".green
puts "\n\n\n\nWhere the Stars Meet the Sky".yellow

prompt.keypress("\n\n\n\n\nPlease press any key to begin.")

system "clear"
@role = prompt.select("Please select your role.", %w(Producer Actor))
if @role == "Producer"
  @@user = producer_sign_in
elsif @role == "Actor"
  @@user = actor_sign_in
  @@user.view_profile
  @@user.profile_menu
end

until (@menu_input == "Exit")

  @@user.main_menu

  @@user.menu_navigate

end


binding.pry

puts "HELLO WORLD"
