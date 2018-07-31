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

    puts "MAIN MENU".blue

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(Create_Opportunity List_All_Opportunities Search_Opportunities_by_Attribute Create_Request Respond_to_Request List_All_Requests Search_Requests_by_Attribute))
  end

def menu_navigate
  case @menu_input
  when "Create_Opportunity"
    @@user.create_opportunity
  when "List_All_Opportunities"
    list_opportunities
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

def show_opportunity_record
  system "clear"
  table = Terminal::Table.new :title => @current_record.character_name do |t|
    t << ["Gender Identity", @current_record.gender]
    t << :separator
    t.add_row ["Age Range", @current_record.age_range]
    t.add_separator
    t.add_row ["Race", @current_record.race]
    t.add_separator
    t.add_row ["Salary", @current_record.salary]
    t.add_separator
    t.add_row ["Dates", @current_record.dates]
  end
  puts table
  @current_record =+ 1
end

def list_opportunities
  @total = CastingOpportunity.all.length

  if @current == nil
    @current = 0
  end

  @current_record = CastingOpportunity.where(status: "Active").order(:id)[@current]

  show_opportunity_record

  opportunity_record_menu
end

def opportunity_record_menu
  prompt = TTY::Prompt.new
  input = prompt.select("\OPTIONS.\n", %w(Next_Record Previous_Record  Create_Request Main_Menu))

  case input
  when "Next_Record"
    @current += 1
    if @current > CastingOpportunity.where(status: "Active").order(:id).length-1
      prompt.keypress("This is the last record on this list. Press any key to continue.")
      @current -= 1
      list_opportunities
    else
      list_opportunities
    end
  when "Previous_Record"
    if @current == 0
      prompt.keypress("\nThere are no previous records on this list. Press any key to continue.")
      list_opportunities
    else
    @current -= 1
    list_opportunities
    end
  when "Create_Request"
    puts "CREATE REQUEST NOT READY- Coming Soon!"
    exit
  when "Main_Menu"
    main_menu
  end
end
