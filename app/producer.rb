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

    puts "MAIN MENU".yellow

    if pending_requests?
      puts "\nYou have #{CastingRequest.where(producer_id: @@user.id, status: "Pending").length} pending casting requests.".red
    else
      puts "\nYou have no pending casting requests."
    end

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(Create_Opportunity List_All_Opportunities List_My_Opportunities Search_Opportunities_by_Attribute Respond_to_Request List_All_Requests Search_Requests_by_Attribute Exit))
  end

  def menu_navigate
    case @menu_input
    when "Create_Opportunity"
      @@user.create_opportunity
    when "List_All_Opportunities"
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
        @current = 0
      @@user.list_opportunities
    when "List_My_Opportunities"
      list_my_opportunities
    when "Search_Opportunities_by_Attribute"
      @@user.search_by_attribute
    when "Respond_to_Request"
      respond_to_request
    when "List_All_Requests"
      puts "\nCOMING SOON: List_All_Requests"
    when "Search_Requests_by_Attribute"
      puts "\nCOMING SOON: Search_Requests_by_Attribute"
    when "Exit"
      puts "Thank you for your visit!"
      exit
    end
  end

  def create_opportunity
    prompt = TTY::Prompt.new

    system "clear"
    @name = prompt.ask("Please enter character name.", required: true)

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
    @dates = prompt.multi_select("Dates: please select all that apply.", choices)

    CastingOpportunity.create(gender: @gender, age_range: @age, race: @race, salary: @salary, dates: @dates, status: "Pending", producer_id: @@user.id, character_name: @name)

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

    if @@current_record[@current].producer_id != @@user.id
      prompt.keypress("\nYou can only delete casting opportunities you create. Press any key to continue.")
      show_opportunity_record
      opportunity_record_menu
    end

    input = prompt.yes?("\nAre you sure you want to delete this casting opportunity?")
    if input == true

      @@current_record[@current].delete

      @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
      prompt.keypress("\nThis casting opportunity has been deleted. Press any key to continue.")

      system "clear"
        if @current == 0
          @current +=1
          show_opportunity_record
          opportunity_record_menu
        else
          @current -=1
          show_opportunity_record
          opportunity_record_menu
        end
    else
      prompt.keypress("\nCasting opportunity was not deleted. Press any key to continue.")
        show_opportunity_record
        opportunity_record_menu
    end
  end

  def edit_opportunity
    prompt = TTY::Prompt.new

    if @@current_record[@current].producer_id != @@user.id
      prompt.keypress("\nYou can only edit the casting opportunities you create. Press any key to continue.")
      show_opportunity_record
      opportunity_record_menu
    end

    show_opportunity_record


    prompt = TTY::Prompt.new
    input = prompt.select("\nPlease select the element you wish to edit.", %w(Character_Name Gender_Identity Age_Range Race Salary Dates Done_Editing))

    case input
    when "Character_Name"
      edit_input = prompt.ask("\nPlease enter new character name:")

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
   end

  end

  #TRYING OUT THE CLI METHODS HERE
  #SHOW OPPORTUNITY RECORD

  def list_opportunities
    if @current == nil
      @current = 0
    end
    show_opportunity_record
    opportunity_record_menu
  end

  def list_my_opportunities

    @@current_record = CastingOpportunity.where(producer_id: @@user.id)
    @current = 0
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
    puts "\n#{@current + 1} of #{@@current_record.length} records"
    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record  Create_Request Delete_Opportunity Edit_Opportunity Main_Menu))

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
    when "Create_Request"
      puts "CREATE REQUEST NOT READY- Coming Soon!"
      exit
    when "Delete_Opportunity"
      @@user.delete_opportunity
    when "Edit_Opportunity"
      @@user.edit_opportunity
    when "Main_Menu"
      # main_menu
    end
  end

  #SEARCH BY ATTRIBUTE
  def search_by_attribute

    prompt = TTY::Prompt.new
    search_hash = {}

    system "clear"
    @gender = prompt.select("If you want to select by gender identity, please make your selection.", %w(Don't_Search_by_Gender Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

    if @gender != "Don't_Search_by_Gender"
      search_hash[:gender] = @gender
    end

    system "clear"
    choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
    @age = prompt.multi_select("If you want to select by age_range, please make your selection.", choices)

    if !@age.empty?
      search_hash[:age_range] = @age
    end

    system "clear"
    @race = prompt.select("If you want to select by race, please make your selection.", %w(Don't_Search_by_Race Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

    if @race != "Don't_Search_by_Race"
      search_hash[:race] = @race
    end

    system "clear"
    @salary = prompt.select("If you want to select by salary, please make your selection.", %w(Don't_Search_by_Salary Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

    if @salary != "Don't_Search_by_Salary"
      search_hash[:salary] =  @salary
    end

    system "clear"
    choices = %w(January February March April May June July August September October November December)
    @dates = prompt.multi_select("If you want to select by dates, please make your selection.", choices)

    if !@dates.empty?
      search_hash[:dates] = @dates
    end

  search_hash_with_strings = search_hash.each_with_object({}) { |(key,value), new_hash| new_hash[key] = value.to_s }

    @@current_record =  CastingOpportunity.where(search_hash_with_strings)
    @current = 0
    if @@current_record.empty?
      input = prompt.yes?("/nNone of the casting opportunities match your query. Would you like to run another search?")
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
    CastingRequest.where(producer_id: @@user.id, status: "Pending").length > 0
  end

  def respond_to_request
  end


end
