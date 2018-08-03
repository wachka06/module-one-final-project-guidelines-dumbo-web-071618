class Actor < ActiveRecord::Base
  has_many :casting_requests
  has_many :producers, through: :casting_opportunities

  def full_name
    "#{first_name} #{last_name}"
  end

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("main menu"))
    puts ""
    puts ""

    view_profile

    if pending_requests?
      puts "\n\nYou have #{CastingRequest.where(actor_id: self.id, status: "Accepted").length} upcoming auditions!".red
    end

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(List_All_Opportunities List_Matching_Opportunities Search_Opportunities_by_Attributes List_Your_Requests Edit_Profile Exit))
  end

  def menu_navigate
    case @menu_input
      when "List_All_Opportunities"
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
        @current = 0
      list_opportunities
    when "List_Matching_Opportunities"
      search_matching_opportunities
    when "Search_Opportunities_by_Attributes"
      search_by_attribute
    when "List_Your_Requests"
      @@current_record = CastingRequest.where(actor_id: self.id)
      @current = 0
      list_your_requests
    when "Edit_Profile"
      edit_profile
    when "Exit"
      show_home_page
      puts "\n\n\n\n\nThank YOU for your visit!\n\n\n\n\n"
      exit
    end
  end

  def view_profile
    table = Terminal::Table.new :title => "#{self.full_name} Profile" do |t|
      t << ["Gender Identity", self.gender]
      t << :separator
      t.add_row ["Age Range", self.age_range]
      t.add_separator
      t.add_row ["Race", self.race]
      t.add_separator
      t.add_row ["Salary", self.salary_range]
      t.add_separator
      t.add_row ["Availability", self.dates]
    end
    puts table
  end

#I Don't Think We Need Profile_menu anymore Since it's part of the main menu now
  # def profile_menu
  #   prompt = TTY::Prompt.new
  #   input = prompt.select("\nOPTIONS.\n", %w(Edit_Profile Main_Menu))
  #
  #   if input == "Edit_Profile"
  #     edit_profile
  #   else
  #     return
  #   end
  # end

  def edit_profile
    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("edit profile"))
    puts ""
    puts ""

    view_profile

    prompt = TTY::Prompt.new
    input = prompt.select("\nPlease select the element you wish to edit.", %w(Gender_Identity Age_Range Race Salary Availability Done_Editing))

    case input
    when "Age_Range"
      choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
      edit_input = prompt.multi_select("Please select the new age ranges that apply.", choices)

      self.update(age_range: edit_input)

      edit_profile

    when "Gender_Identity"
      edit_input = prompt.select("Please select gender identity.", %w(Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

      self.update(gender: edit_input)

      edit_profile

    when "Race"
      edit_input = prompt.select("Please select race.", %w(Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

      self.update(race: edit_input)

      edit_profile

    when "Salary"
      edit_input = prompt.select("Please select salary.", %w(Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

      self.update(salary_range: edit_input)

      edit_profile

    when "Availability"
      choices = %w(January February March April May June July August September October November December)
      edit_input = prompt.multi_select("Dates: please select all that apply.", choices)

      self.update(dates: edit_input)

      edit_profile

    when "Done_Editing"
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
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("all roles"))
    puts ""
    puts ""

    puts table
  end

  def opportunity_record_menu
    prompt = TTY::Prompt.new
    puts "\n#{@current + 1} of #{@@current_record.length} records"
    input = prompt.select("\nOPTIONS.\n", %w(Next_Record Previous_Record  Create_Request Main_Menu))

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
      create_request
    when "Main_Menu"
      return
    end
  end

  def search_matching_opportunities
    prompt = TTY::Prompt.new

    @@current_record = CastingOpportunity.where(gender: self.gender, age_range: self.age_range, race: self.race, salary: self.salary_range, dates: self.dates)
    @current = 0

    if @@current_record.empty?
     prompt.keypress("\nNone of the casting opportunities currently match your criteria. Press any key to return to menu.")
     @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
     @current = 0
     return
    end
   list_opportunities
 end

  def create_request
    prompt = TTY::Prompt.new
    if !CastingRequest.find_by(actor_id: self.id, castingopportunity_id: @@current_record[@current].id, producer_id: @@current_record[@current].producer_id).nil?
      puts "\nYou've already requested an audition for this role."
      prompt.keypress("\nBE PATIENT.\n".red)

      show_opportunity_record
      opportunity_record_menu
    else
      CastingRequest.create(actor_id: self.id, castingopportunity_id: @@current_record[@current].id, producer_id: @@current_record[@current].producer_id, status: "Pending")

      puts "\nYour request to audition for the part of #{@@current_record[@current].character_name} has been sent to the producer."

      prompt.keypress("\nPlease press any key to continue.")
      show_opportunity_record
      opportunity_record_menu
    end
  end

  def list_your_requests
    prompt = TTY::Prompt.new

    @opportunities = @@current_record.map do |request|
      [request.castingopportunity_id, request.id]
    end

    system "clear"
    prompt = TTY::Prompt.new

    font = TTY::Font.new(:doom)
    pastel = Pastel.new

    puts pastel.yellow(font.write("casting requests"))
    puts ""
    puts ""

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

    requests_menu
  end

  def requests_menu
    prompt = TTY::Prompt.new

    input = prompt.select("\nOPTIONS.\n", %w(Order_by_Status Order_by_Date Main_Menu))

    case input
      # when "Delete_Request"
      #   delete_request
      when "Order_by_Status"
        order_by_status
      when "Order_by_Date"
        order_by_date
    end
  end

  def order_by_status
    @@current_record = CastingRequest.where(actor_id: self.id).order (:status)
    list_your_requests
  end

  def order_by_date
    @@current_record = CastingRequest.where(actor_id: self.id).order (:id)
    list_your_requests
  end

  def search_by_attribute
    prompt = TTY::Prompt.new
    search_hash = {}

  search_header

    @gender = prompt.select("Gender Identity", %w(Don't_Search_by_Gender Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))

    if @gender != "Don't_Search_by_Gender"
      search_hash[:gender] = @gender
    end

    search_header

    choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
    @age = prompt.multi_select("Age Range", choices)

    if !@age.empty?
      search_hash[:age_range] = @age
    end

    search_header

    @race = prompt.select("Race", %w(Don't_Search_by_Race Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))

    if @race != "Don't_Search_by_Race"
      search_hash[:race] = @race
    end

    search_header

    @salary = prompt.select("Salary Range", %w(Don't_Search_by_Salary Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))

    if @salary != "Don't_Search_by_Salary"
      search_hash[:salary] =  @salary
    end

    search_header

    choices = %w(January February March April May June July August September October November December)
    @dates = prompt.multi_select("Dates", choices)

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
    CastingRequest.where(actor_id: self.id, status: "Accepted").length > 0
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

#COULD NOT GET IT TO WORK_REVISIT
  # def delete_request
  #   prompt = TTY::Prompt.new
  #
  #   character_names = @opportunities.map do |id|
  #     CastingOpportunity.find(id[0]).character_name
  #   end
  #
  #   choices = %w(#{character_names})
  #   edit_input = prompt.multi_select("Please select the new age ranges that apply.", choices)
  #
  #
  #   input = prompt.yes?("\nAre you sure you want to delete this casting opportunity?")
  #   if input == true
  #
  #     @@current_record[@current].delete
  #
  #     @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
  #     prompt.keypress("\nThis casting opportunity has been deleted. Press any key to continue.")
  #
  #     system "clear"
  #       if @current == 0
  #         @current +=1
  #         show_opportunity_record
  #         opportunity_record_menu
  #       else
  #         @current -=1
  #         show_opportunity_record
  #         opportunity_record_menu
  #       end
  #   else
  #     prompt.keypress("\nCasting opportunity was not deleted. Press any key to continue.")
  #       show_opportunity_record
  #       opportunity_record_menu
  #   end
  # end
end
