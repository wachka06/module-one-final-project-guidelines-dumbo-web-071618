class Actor < ActiveRecord::Base
  has_many :casting_requests
  has_many :producers, through: :casting_opportunities

  def full_name
    "#{first_name} #{last_name}"
  end

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    puts "MAIN MENU".yellow

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(List_All_Opportunities List_Matching_Opportunities List_Your_Requests View_Profile Exit))
  end

  def menu_navigate
    case @menu_input
      when "List_All_Opportunities"
        @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
        @current = 0
      list_opportunities
    when "List_Matching_Opportunities"
      search_matching_opportunities
    when "List_Your_Requests"
      list_your_requests
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
    table = Terminal::Table.new :title => "#{@@user.full_name} Profile" do |t|
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
      # main_menu
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
      # main_menu
    end
  end

  def search_matching_opportunities
    prompt = TTY::Prompt.new

    @@current_record = CastingOpportunity.where(gender: @@user.gender, age_range: @@user.age_range, race: @@user.race, salary: @@user.salary_range, dates: @@user.dates)
    @current = 0

    if @@current_record.empty?
     prompt.keypress("None of the casting opportunities currently match your criteria. Press any key to return to menu.")
     @@current_record = CastingOpportunity.where.not(status: "Closed").order(:id)
     @current = 0
     # main_menu
    end
   list_opportunities
 end

  def create_request
    prompt = TTY::Prompt.new
    if !CastingRequest.find_by(actor_id: @@user.id, castingopportunity_id: @@current_record[@current].id, producer_id: @@current_record[@current].producer_id).nil?
      prompt.keypress("You've already requested an audition for this role. BE PATIENT.")
    else
      CastingRequest.create(actor_id: @@user.id, castingopportunity_id: @@current_record[@current].id, producer_id: @@current_record[@current].producer_id, status: "Pending")

      puts "Your request to audition for the part of #{@@current_record[@current].character_name} has been sent to the producer."

      prompt.keypress("\nPlease press any key to continue.")
    end
  end

  def list_your_requests
    prompt = TTY::Prompt.new

    my_requests = CastingRequest.where(actor_id: @@user.id)

    opportunities = my_requests.map do |request|
      request.castingopportunity_id
    end

    puts "\nYou've requested to audition for the following roles:"

    system "clear"

    puts "#{@@user.full_name} Casting Requests\n".yellow

    table = Terminal::Table.new :headings => ["Character Name", "Status"]

    puts table

    opportunities.map do |opportunity|
    table = Terminal::Table.new do |t|
      t << [CastingOpportunity.find(opportunity).character_name, CastingOpportunity.find(opportunity).status]
    end
    puts table
  end
    prompt.keypress("\nPress any key to continue.")
end
end
