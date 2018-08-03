require_relative '../config/environment'

prompt = TTY::Prompt.new

system "clear"

puts "\n\nHORIZON".green
puts "\n\n\n\nWhere the Stars Meet the Sky".yellow

prompt.keypress("\n\n\n\n\nPlease press any key to begin.")

system "clear"
@role = prompt.select("Please select your role.", %w(Producer Actor))
if @role == "Producer"
  current_user = producer_sign_in
elsif @role == "Actor"
  current_user = actor_sign_in
end

until (@menu_input == "Exit")

  current_user.main_menu

  current_user.menu_navigate

end


puts "HELLO WORLD"
