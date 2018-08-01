class Actor < ActiveRecord::Base
  has_many :casting_requests
  has_many :producers, through: :casting_opportunitys

  def full_name
    "#{first_name} #{last_name}"
  end

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    puts "MAIN MENU".yellow

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(List_All_Opportunities List_Matching_Opportunities Create_Request Respond_to_Request List_Your_Requests List_Producer_Requests View_Profile Exit))
  end

  def menu_navigate
    case @menu_input
      when "List_All_Opportunities"
        @@current_record = CastingOpportunity.where(status: "Active").order(:id)
        @current = 0
      @@user.list_opportunities
    when "List_Matching_Opportunities"
      puts "WORKING ON IT...SOMING SOON!"
    when "Create_Request"
      puts "\nCOMING SOON: Create_Request"
    when "Respond_to_Request"
      puts "\nCOMING SOON: Respond_to_Request"
    when "List_Your_Requests"
      puts "\nCOMING SOON: List_Your_Requests"
    when "List_Producer_Requests"
      puts "\nCOMING SOON: List_Producer_Requests"
    when "View_Profile"
      view_profile
      profile_menu
    when "Exit"
      puts "Thank you for your visit!"
      exit
    end
  end

  def view_profile
    system "clear"
    table = Terminal::Table.new :title => @@user.full_name do |t|
      t << ["Gender Identity", @@user.gender]
      t << :separator
      t.add_row ["Age Range", @@user.age_range]
      t.add_separator
      t.add_row ["Race", @@user.race]
      t.add_separator
      t.add_row ["Salary", @@user.salary_range]
      t.add_separator
      t.add_row ["Availability", @@user.dates]
    end
    puts table
  end

  def profile_menu
    prompt = TTY::Prompt.new
    input = prompt.select("\nOPTIONS.\n", %w(Edit_Profile Main_Menu))

    if input == "Edit_Profile"
      edit_profile
    else
      main_menu
    end
  end

  def edit_profile
    view_profile

    prompt = TTY::Prompt.new
    input = prompt.select("\nPlease select the element you wish to edit.", %w(Gender_Identity Age_Range Race Salary Availability Done_Editing))

    case input
    when "Age_Range"
      choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
      edit_input = prompt.multi_select("Please select the new age ranges that apply.", choices)

      @@user.update(age_range: edit_input)

      edit_profile

    when "Gender_Identity"
      edit_input = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

      @@user.update(gender: edit_input)

      edit_profile

    when "Race"
      edit_input = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

      @@user.update(race: edit_input)

      edit_profile

    when "Salary"
      edit_input = prompt.select("Please select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

      @@user.update(salary_range: edit_input)

      edit_profile

    when "Availability"
      choices = %w(January February March April May June July August September October November December)
      edit_input = prompt.multi_select("Dates: please select all that apply.", choices)

      @@user.update(dates: edit_input)

      edit_profile
   end
  end

  def list_opportunities
    if @current == nil
      @current = 0
    end
    show_opportunity_record
    opportunity_record_menu
  end

  def show_opportunity_record
    system "clear"
    table = Terminal::Table.new :title => @@current_record[@current].character_name do |t|
      t << ["Gender Identity", @@current_record[@current].gender]
      t << :separator
      t.add_row ["Age Range", @@current_record[@current].age_range]
      t.add_separator
      t.add_row ["Race", @@current_record[@current].race]
      t.add_separator
      t.add_row ["Salary", @@current_record[@current].salary]
      t.add_separator
      t.add_row ["Dates", @@current_record[@current].dates]
    end
    puts table
  end

  def opportunity_record_menu
    prompt = TTY::Prompt.new
    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record  Create_Request Main_Menu))

    case input
    when "Next_Record"
      @current += 1

      if @current > @@current_record.length-1
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

end
