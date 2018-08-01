class Actor < ActiveRecord::Base
  has_many :casting_requests
  has_many :producers, through: :casting_opportunitys

  def full_name
    "#{first_name} #{last_name}"
  end

  def main_menu
    system "clear"
    prompt = TTY::Prompt.new

    puts "MAIN MENU".blue

    @menu_input = prompt.select("\nPlease select from the following options.\n", %w(List_All_Opportunities List_Matching_Opportunities Create_Request Respond_to_Request List_Your_Requests List_Producer_Requests Exit))
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
    when "Exit"
      puts "Thank you for your visit!"
      exit
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
