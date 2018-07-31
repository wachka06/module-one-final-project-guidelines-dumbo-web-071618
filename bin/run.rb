require_relative '../config/environment'

roberto = Actor.find(1)
natsuki = Producer.find(1)

prompt = TTY::Prompt.new

#WE STILL NEED WELCOME MESSAGE AND SIGN-IN LOG-IN OPTIONS
system "clear"
@role = prompt.select("Please select your role.", %w(Producer Actor))
if @role == "Producer"
  @user = producer_sign_in
elsif @role == "Actor"
  @user = actor_sign_in
end

main_menu

menu_navigate



binding.pry

puts "HELLO WORLD"
