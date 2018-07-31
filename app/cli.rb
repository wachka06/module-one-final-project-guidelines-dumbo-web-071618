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

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    puts "MAIN MENU".yellow

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(Create_Opportunity List_All_Opportunities Search_Opportunities_by_Attribute Create_Request Respond_to_Request List_All_Requests Search_Requests_by_Attribute))
  end

def menu_navigate
  case @menu_input
  when "Create_Opportunity"
    create_opportunity
  when "List_All_Opportunities"
    puts "\nCOMING SOON: List_All_Opportunities"
  when "Search_Opportunities_by_Attribute"
    puts "\nCOMING SOON: Search_Opportunities_by_Attribute"
  when "Create_Request"
    puts "\nCOMING SOON: Create_Request"
  when "Respond_to_Request"
    puts "\nCOMING SOON: Respond_to_Request"
  when "List_All_Requests"
    puts "\nCOMING SOON: List_All_Requests"
  when "Search_Requests_by_Attribute"
    puts "\nCOMING SOON: Search_Requests_by_Attribute"
  end
end

#Change .new to .create
def create_opportunity
  prompt = TTY::Prompt.new

  system "clear"
  @name = prompt.ask("Please enter character name.")

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
  @dates = prompt.multi_select("Dates: please select all that apply.", choices)

  CastingOpportunity.new(gender: @gender, age_range: @age, race: @race, salary: @salary, dates: @dates, status: "Active", producer_id: @user.id)

  show_opportunity_record
end

def show_opportunity_record
  prompt = TTY::Prompt.new
  system "clear"
  table = Terminal::Table.new :title => @name do |t|
    t << ["Gender Identity", @gender]
    t << :separator
    t.add_row ["Age Range", @age]
    t.add_separator
    t.add_row ["Race", @race]
  end

  puts table

  input = prompt.select("\nOPTIONS") do |menu|
    menu.choice "Edit Opportunity", 1
    menu.choice "Main Menu", 2
  end

  if input == 1
    puts "GOES TO UPDATE: COMING SOON!".yellow
  elsif input == 2
    main_menu
  end
end
