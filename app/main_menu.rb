def main_menu
  system "clear"
  prompt = TTY::Prompt.new

  puts "MAIN MENU".blue

  @menu_input = prompt.select("\nPlease select from the following options.\n", %w(Create_Opportunity List_All_Opportunities Search_Opportunities_by_Attribute Create_Request Respond_to_Request List_All_Requests Search_Requests_by_Attribute Exit))
end

def menu_navigate
  case @menu_input
  when "Create_Opportunity"
    @@user.create_opportunity
  when "List_All_Opportunities"
      @@current_record = CastingOpportunity.where(status: "Active").order(:id)
      @current = 0
    @@user.list_opportunities
  when "Search_Opportunities_by_Attribute"
    @@user.search_by_attribute
  when "Create_Request"
    puts "\nCOMING SOON: Create_Request"
  when "Respond_to_Request"
    puts "\nCOMING SOON: Respond_to_Request"
  when "List_All_Requests"
    puts "\nCOMING SOON: List_All_Requests"
  when "Search_Requests_by_Attribute"
    puts "\nCOMING SOON: Search_Requests_by_Attribute"
  when "Exit"
    puts "Thank you for your visit!"
    exit
  end
end
