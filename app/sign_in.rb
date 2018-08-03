def show_home_page
  system "clear"
  font = TTY::Font.new(:doom)
  pastel = Pastel.new
  puts pastel.bright_magenta(font.write("HORIZON"))
  puts " "
  font = TTY::Font.new(:straight)
  puts pastel.bright_cyan(font.write("where the stars meet the sky"))
end

def get_name
  show_home_page
  prompt = TTY::Prompt.new
  puts "\n\n\n\n\nPlease enter your full name.\n\n"
  name = gets.chomp
    if name.nil? || name == ""
      prompt.kepypress("\nPlease enter your name.")
      get_name
    else
      split_name = name.split(" ")
      @first_name = split_name[0]
      @last_name = split_name[1]
    end
end

def log_in
  show_home_page
  puts "\n\n\n\n\nWelcome back to HORIZON, #{@first_name} #{@last_name}!".yellow
  prompt = TTY::Prompt.new
  prompt.keypress("\n\nPlease press any key to continue.")
  Producer.find_by(first_name: @first_name, last_name: @last_name)
end

def producer_sign_in
  get_name
  if Producer.find_by(first_name: @first_name, last_name: @last_name) != nil
    # puts "\nYou have an account already. Please log in with your username and password."
    log_in
  else
    show_home_page
    puts "\n\n\n\n\nWelcome to HORIZON, #{@first_name} #{@last_name}!".yellow
    prompt = TTY::Prompt.new
    prompt.keypress("\n\nPlease press any key to continue.")
    Producer.create(first_name: @first_name, last_name: @last_name)
  end
end

def actor_sign_in
  get_name
  prompt = TTY::Prompt.new
    if Actor.find_by(first_name: @first_name, last_name: @last_name) != nil
      prompt.keypress("\nYou already have a profile. Press any key to continue.")
      @@user = Actor.find_by(first_name: @first_name, last_name: @last_name)
    else
        create_profile
    end
  end

def create_profile
  show_home_page
  prompt = TTY::Prompt.new

  prompt.keypress("\n\n\n\n\nLet's create your profile.\n\nThis information will be used to search for the specific casting opportunities that match your criteria.")

  show_home_page
  @gender = prompt.select("\n\n\n\n\nPlease select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

  show_home_page
  choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
  @age = prompt.multi_select("\n\n\n\n\nAge Range: please select all that apply.", choices)

  show_home_page
  @race = prompt.select("\n\n\n\n\nPlease select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

  show_home_page
  @salary = prompt.select("\n\n\n\n\nPlease select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

  show_home_page
  choices = %w(January February March April May June July August September October November December)
  @dates = prompt.multi_select("\n\n\n\n\nPlease select the months when you're available.", choices)

  Actor.create(first_name: @first_name, last_name: @last_name, gender: @gender, age_range: @age, race: @race, salary_range: @salary, dates: @dates)
end
