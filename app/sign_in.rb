def get_name
  system "clear"
  prompt = TTY::Prompt.new
  name = prompt.ask("Please enter your full name.", required: true)
  split_name = name.split(" ")
  @first_name = split_name[0]
  @last_name = split_name[1]
end

def log_in
  puts "\nCOMING SOON".yellow
  puts"\n\nSTILL WORKING ON IT!".red
  prompt = TTY::Prompt.new
  prompt.keypress("But hey, let's test on. Press any key to proceed.")
  Producer.find_by(first_name: @first_name, last_name: @last_name)
end

#Change .new to .create
def producer_sign_in
  get_name
  if Producer.find_by(first_name: @first_name, last_name: @last_name) != nil
    puts "You have an account already. Please log in with your username and password."
    log_in
  else
    Producer.new(first_name: @first_name, last_name: @last_name)
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
  prompt = TTY::Prompt.new

  prompt.keypress("Let's create your profile. This information will be used when you search for the specific casting opportunities that match your criteria.")

  system "clear"
  @gender = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

  system "clear"
  choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
  @age = prompt.multi_select("Age Range: please select all that apply.", choices)

  system "clear"
  @race = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

  system "clear"
  @salary = prompt.select("Please select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

  system "clear"
  choices = %w(January February March April May June July August September October November December)
  @dates = prompt.multi_select("Please select the months when you're available.", choices)

  Actor.create(first_name: @first_name, last_name: @last_name, gender: @gender, age_range: @age, race: @race, salary_range: @salary, dates: @dates)
end
