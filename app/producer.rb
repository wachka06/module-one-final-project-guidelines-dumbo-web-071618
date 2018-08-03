class Producer < ActiveRecord::Base
  has_many :casting_opportunities
  has_many :casting_requests
  has_many :actors, through: :casting_opportunities

  def full_name
    "#{first_name} #{last_name}"
  end

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("main menu"))
    puts ""
    puts ""
    puts "Welcome #{self.full_name}!"
    current_roles_producer

    if pending_requests?
      puts "\n\nYou have #{CastingRequest.where(producer_id: self.id, status: "Pending").length} casting requests pending.\n".red
    else
      puts "\nYou have no pending casting requests.\n"
    end

  @menu_input = prompt.select("\nPlease select from the following options.\n", %w(Create_Opportunity List_All_Opportunities List_My_Opportunities Search_Opportunities_by_Attribute List_Requests View_Actor_Profiles Exit))
  end

  def menu_navigate
    case @menu_input
    when "Create_Opportunity"
      self.create_opportunity
    when "List_All_Opportunities"
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
        @current = 0
        @my_opportunity = 0
      self.list_opportunities
    when "List_My_Opportunities"
      @my_opportunity = 1
      list_my_opportunities
    when "Search_Opportunities_by_Attribute"
      self.search_by_attribute
    when "List_Requests"
      @@current_record = CastingRequest.where(producer_id: self.id)
      @current = 0
      list_requests
    when "View_Actor_Profiles"
      @current = 0
      view_actor_profiles
    when "Exit"
      show_home_page
      puts "\n\n\n\n\nThank YOU for your visit!\n\n\n\n\n"
      exit
    end
  end

  def create_opportunity
    prompt = TTY::Prompt.new

    in_progress_table
    @name = prompt.ask("Please enter character name.", required: true)

    in_progress_table
    @gender = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

    in_progress_table
    choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
    @age = prompt.multi_select("Age Range: please select all that apply.", choices)

    in_progress_table
    @race = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

    in_progress_table
    @salary = prompt.select("Please select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

    in_progress_table
    choices = %w(January February March April May June July August September October November December)
    @dates = prompt.multi_select("Dates: please select all that apply.", choices)

    CastingOpportunity.create(gender: @gender, age_range: @age, race: @race, salary: @salary, dates: @dates, status: "Pending", producer_id: self.id, character_name: @name)

    system "clear"
    table = Terminal::Table.new :title => @name do |t|
      t << ["Gender Identity", @gender]
      t << :separator
      t.add_row ["Age Range", @age]
      t.add_separator
      t.add_row ["Race", @race]
      t.add_separator
      t.add_row ["Salary", @salary]
      t.add_separator
      t.add_row ["Dates", @dates]
    end
    puts table

    @name = @gender = @age = @race = @salary = @dates = ""

    input = prompt.select("\nOPTIONS") do |menu|
      menu.choice "Edit Opportunity", 1
      menu.choice "Main Menu", 2
    end

    if input == 1
      @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
      @current = CastingOpportunity.all.length - 1
      edit_opportunity
    elsif input == 2
      # main_menu
    end
  end

  def delete_opportunity
    prompt = TTY::Prompt.new

    if @@current_record[@current].producer_id != self.id
      prompt.keypress("\nYou can only delete casting opportunities you create. Press any key to continue.")
      show_opportunity_record
      opportunity_record_menu
      return
    end

    puts "\nAre you sure you want to delete this casting opportunity? (y/n)"
    input = gets.chomp

    if input == "y" || input == "Y" || input == "yes"
      @@current_record[@current].destroy

      CastingRequest.where(castingopportunity_id: @@current_record[@current].id).destroy_all

      @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)

      prompt.keypress("\nThis casting opportunity has been deleted. Press any key to continue.")

    else
      prompt.keypress("\nCasting opportunity was not deleted. Press any key to continue.")
        show_opportunity_record
        opportunity_record_menu
        return
    end

      if @my_opportunity == 1
        @@current_record = CastingOpportunity.where(producer_id: self.id)
      else @my_opportunity == 0
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
      end

      if @@current_record.length < 1
        prompt.keypress("Currently there are no active casting opportunities.")
        return
      elsif
        @current == 0
        @current += 1
        show_opportunity_record
        opportunity_record_menu
      else
        @current -= 1
          show_opportunity_record
          opportunity_record_menu
      end

  end

  def edit_opportunity
    prompt = TTY::Prompt.new

    if @@current_record[@current].producer_id != self.id
      prompt.keypress("\nYou can only edit the casting opportunities you create. Press any key to continue.")
      show_opportunity_record
      opportunity_record_menu
      return
    end

    show_opportunity_record

    prompt = TTY::Prompt.new
    input = prompt.select("\nPlease select the element you wish to edit.", %w(Character_Name Gender_Identity Age_Range Race Salary Dates Done_Editing))

    case input
    when "Character_Name"
      puts "\nPlease enter new character name:"
      edit_input = gets.chomp

      @@current_record[@current].update(character_name: edit_input)

      edit_opportunity

    when "Age_Range"
      choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
      edit_input = prompt.multi_select("Please select the new age ranges that apply.", choices)

      @@current_record[@current].update(age_range: edit_input)

      edit_opportunity

    when "Gender_Identity"
      edit_input = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

      @@current_record[@current].update(gender: edit_input)

      edit_opportunity
    when "Race"
      edit_input = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

      @@current_record[@current].update(race: edit_input)

      edit_opportunity

    when "Salary"
      edit_input = prompt.select("Please select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

      @@current_record[@current].update(salary: edit_input)

      edit_opportunity

    when "Dates"
      choices = %w(January February March April May June July August September October November December)
      edit_input = prompt.multi_select("Dates: please select all that apply.", choices)

      @@current_record[@current].update(dates: edit_input)

      edit_opportunity

    when"Done_Editing"
      return
   end
  end

  def list_opportunities
    if @current == nil
      @current = 0
    end
    show_opportunity_record
    opportunity_record_menu
  end

  def list_my_opportunities
    prompt = TTY::Prompt.new
    @@current_record = CastingOpportunity.where(producer_id: self.id)
    @current = 0

    if @@current_record.length < 1
      prompt.keypress("\nYou have no casting opportunities. Press any key to continue.")
      return
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
    if @my_opportunity == 0
      prompt = TTY::Prompt.new

      font = TTY::Font.new(:doom)
      pastel = Pastel.new

      puts pastel.yellow(font.write("all roles"))
      puts ""
      puts ""

    else
      prompt = TTY::Prompt.new

      font = TTY::Font.new(:doom)
      pastel = Pastel.new

      puts pastel.yellow(font.write("your queries"))
      puts ""
      puts ""

    end
    puts table

    if @@current_record[@current].producer_id == self.id
      puts "\nYou created this casting opportunity. You can edit it or delete it.".yellow
    end
  end

  def opportunity_record_menu
    prompt = TTY::Prompt.new
    puts "\n#{@current + 1} of #{@@current_record.length} records"
    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record Delete_Opportunity Edit_Opportunity Main_Menu))

    case input
    when "Next_Record"
      @current += 1

      if @current > @@current_record.length-1
        prompt.keypress("\nThis is the last record on this list. Press any key to continue.")
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
    when "Delete_Opportunity"
      self.delete_opportunity
    when "Edit_Opportunity"
      self.edit_opportunity
    when "Main_Menu"
      # main_menu
    end
  end

  def search_by_attribute
    prompt = TTY::Prompt.new
    search_hash = {}

    search_header
    @gender = prompt.select("If you want to select by gender identity, please make your selection.", %w(Don't_Search_by_Gender Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

    if @gender != "Don't_Search_by_Gender"
      search_hash[:gender] = @gender
    end

    search_header
    choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
    @age = prompt.multi_select("If you want to select by age_range, please make your selection.", choices)

    if !@age.empty?
      search_hash[:age_range] = @age
    end

    search_header
    @race = prompt.select("If you want to select by race, please make your selection.", %w(Don't_Search_by_Race Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

    if @race != "Don't_Search_by_Race"
      search_hash[:race] = @race
    end

    search_header
    @salary = prompt.select("If you want to select by salary, please make your selection.", %w(Don't_Search_by_Salary Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

    if @salary != "Don't_Search_by_Salary"
      search_hash[:salary] =  @salary
    end

    search_header
    choices = %w(January February March April May June July August September October November December)
    @dates = prompt.multi_select("If you want to select by dates, please make your selection.", choices)

    if !@dates.empty?
      search_hash[:dates] = @dates
    end

  search_hash_with_strings = search_hash.each_with_object({}) { |(key,value), new_hash| new_hash[key] = value.to_s }

    @@current_record =  CastingOpportunity.where(search_hash_with_strings)
    @current = 0
    if @@current_record.empty?
      input = prompt.yes?("\nNone of the casting opportunities match your query. Would you like to run another search?")
      if input == true
        search_by_attribute
      else
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
        @current = 0
        # main_menu
      end
    end
    list_opportunities
  end

  def pending_requests?
    CastingRequest.where(producer_id: self.id, status: "Pending").length > 0
  end

  def list_requests
    prompt = TTY::Prompt.new

    if @@current_record.length < 1
      prompt.keypress("\nYou have no pending casting requests.")
      return
    end

    @actor = Actor.find(@@current_record[@current].actor_id)

    actor_name = Actor.find(@@current_record[@current].actor_id).full_name

    character_name = CastingOpportunity.find(@@current_record[@current].castingopportunity_id).character_name

    request_status = @@current_record[@current].status

    system "clear"

    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("casting requests"))
    puts ""
    puts ""

    table = Terminal::Table.new :headings => [["Actor Name".yellow, "Character Name".yellow, "Status".yellow]], :rows => [[actor_name, character_name, request_status.red]], :style => {:width => 60}

    puts table
    puts " "
    puts " "

    show_actor_profile

    requests_menu
  end

  def requests_menu
    prompt = TTY::Prompt.new

    puts "\n#{@current + 1} of #{@@current_record.length} records"

    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record View_Actor's_Casting_Record Accept_Request Deny_Request Main_Menu))

    case input
    when "Next_Record"
      @current += 1
      if @current > @@current_record.length-1
        prompt.keypress("\nThis is the last record on this list. Press any key to continue.")
        @current -= 1
        list_requests
      else
        list_requests
      end
    when "Previous_Record"
      if @current == 0
        prompt.keypress("\nThere are no previous records on this list. Press any key to continue.")
        list_requests
      else
      @current -= 1
      list_requests
      end
    when "View_Actor's_Casting_Record"
      @x = @@current_record[@current].actor_id
      @@current_record = CastingRequest.where(actor_id: @x)
      view_actor_record
    when "Accept_Request"
      accept_request
    when "Deny_Request"
      deny_request
    end
  end

  def show_actor_profile
    table = Terminal::Table.new :title => "#{@actor.full_name} Profile".yellow do |t|
      t << ["Gender Identity", @actor.gender]
      t << :separator
      t.add_row ["Age Range", @actor.age_range]
      t.add_separator
      t.add_row ["Race", @actor.race]
      t.add_separator
      t.add_row ["Salary", @actor.salary_range]
      t.add_separator
      t.add_row ["Availability", @actor.dates]
    end
    puts table
  end

  def accept_request
    @@current_record[@current].update(status: "Accepted")
    list_requests
  end

  def deny_request
    @@current_record[@current].update(status: "Denied")
    list_requests
  end

  def view_actor_record
    prompt = TTY::Prompt.new

    @opportunities = @@current_record.map do |request|
      [request.castingopportunity_id, request.id]
    end

    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("actor's record"))
    puts ""
    puts ""



    puts "\n#{Actor.find(@x).first_name} has requested auditions for the following roles:\n"

    table = Terminal::Table.new :rows => [["Character Name".yellow, "Status".yellow]], :style => {:width => 60}

    table.align_column(0, :center)
    table.align_column(1, :center)

    puts table

    @opportunities.map do |opportunity|
      table = Terminal::Table.new :style => {:width => 60} do |t|
        t << [CastingOpportunity.find(opportunity[0]).character_name, CastingRequest.find(opportunity[1]).status]
      end

      table.align_column(0, :center)
      table.align_column(1, :center)
      puts table
    end
    actor_record_menu
  end

  def actor_record_menu
    prompt = TTY::Prompt.new

    input = prompt.select("\nOPTIONS.\n", %w(Order_by_Status Order_by_Date Back_to_Casting_Requests))

    case input
      # when "Delete_Request"
      #   delete_request
      when "Order_by_Status"
        order_by_status
      when "Order_by_Date"
        order_by_date
      when "Back_to_Casting_Requests"
        @@current_record = CastingRequest.where(producer_id: self.id)
        @current = 0
        list_requests
    end
  end

  def order_by_status
    @@current_record = CastingRequest.where(actor_id: @x).order (:status)
    view_actor_record
  end

  def order_by_date
    @@current_record = CastingRequest.where(actor_id: @x).order (:id)
    view_actor_record
  end

  def view_actor_profiles
    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("actor profiles"))
    puts ""
    puts ""

    @actor = Actor.all[@current]
    show_actor_profile
    actor_profile_menu
  end

  def actor_profile_menu
    prompt = TTY::Prompt.new

    puts "\n#{@current + 1} of #{Actor.all.length} records"

    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record Main_Menu))

    case input
    when "Next_Record"
      @current += 1
      if @current > Actor.all.length-1
        prompt.keypress("\nThis is the last record on this list. Press any key to continue.")
        @current -= 1
        view_actor_profiles
      else
        view_actor_profiles
      end
    when "Previous_Record"
      if @current == 0
        prompt.keypress("\nThere are no previous records on this list. Press any key to continue.")
        view_actor_profiles
      else
      @current -= 1
      view_actor_profiles
      end
    end
  end

  def in_progress_table
    system "clear"
    table = Terminal::Table.new :title => @name do |t|
      t << ["Gender Identity", @gender]
      t << :separator
      t.add_row ["Age Range", @age]
      t.add_separator
      t.add_row ["Race", @race]
      t.add_separator
      t.add_row ["Salary", @salary]
      t.add_separator
      t.add_row ["Dates", @dates]
    end
    puts table
    puts " "
    puts " "
  end

  def current_roles_producer
    rows = []
    row_number = 0
     my_opportunities = CastingOpportunity.where(producer_id: self.id)

     if my_opportunities.length < 1
       "Currently, you're not casting any roles."
     else
       puts "\nYou're currently casting the following roles:\n"
       my_opportunities.each do |opportunity|
         rows << [opportunity.character_name, ""]
         end

       puts " "
       puts Terminal::Table.new :rows => rows, :style => {:width => 30}, :border_x => "="
     end
   end

   def search_header
     system "clear"
     prompt = TTY::Prompt.new

     font = TTY::Font.new(:doom)
     pastel = Pastel.new

     puts pastel.yellow(font.write("search"))
     puts ""
     puts ""
   end

end
