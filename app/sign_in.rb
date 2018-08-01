def get_name
  system "clear"
  prompt = TTY::Prompt.new
  name = prompt.ask("Please enter your full name.", required: true)
  split_name = name.split(" ")
  @first_name = split_name[0]
  @last_name = split_name[1]
  check_name
end

def check_name
  if Producer.find_by(first_name: @first_name, last_name: @last_name) != nil || Actor.find_by(first_name: @first_name, last_name: @last_name) != nil
    puts "You have an account already. Please log in with your username and password."
    log_in
  end
end

def log_in
  puts "\nCOMING SOON".yellow
  puts"\n\nSTILL WORKING ON IT!".red
  exit
end

#Change .new to .create
def producer_sign_in
  get_name
  Producer.new(first_name: @first_name, last_name: @last_name)
end

#Change .new to .create
def actor_sign_in
  get_name
  Actor.new(first_name: @first_name, last_name: @last_name)
  end
