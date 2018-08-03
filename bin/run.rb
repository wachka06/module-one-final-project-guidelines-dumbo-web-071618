require_relative '../config/environment'

system "clear"

show_home_page

prompt = TTY::Prompt.new

@role = prompt.select("\n\n\n\n\nPlease select your role.", %w(Producer Actor))
if @role == "Producer"
  current_user = producer_sign_in
elsif @role == "Actor"
  current_user = actor_sign_in
end

until (@menu_input == "Exit")

  current_user.main_menu

  current_user.menu_navigate

end

show_home_page

puts "\n\n\n\n\nThank you for your visit!"
