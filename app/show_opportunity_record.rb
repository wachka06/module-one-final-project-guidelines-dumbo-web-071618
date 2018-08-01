# def list_opportunities
#   if @current == nil
#     @current = 0
#   end
#
#   show_opportunity_record
#
#   opportunity_record_menu
# end
#
#
# def show_opportunity_record
#   system "clear"
#   table = Terminal::Table.new :title => @current_record[@current].character_name do |t|
#     t << ["Gender Identity", @current_record[@current].gender]
#     t << :separator
#     t.add_row ["Age Range", @current_record[@current].age_range]
#     t.add_separator
#     t.add_row ["Race", @current_record[@current].race]
#     t.add_separator
#     t.add_row ["Salary", @current_record[@current].salary]
#     t.add_separator
#     t.add_row ["Dates", @current_record[@current].dates]
#   end
#   puts table
# end
#
#
# def opportunity_record_menu
#   prompt = TTY::Prompt.new
#   input = prompt.select("\OPTIONS.\n", %w(Next_Record Previous_Record  Create_Request Delete_Opportunity Edit_Opportunity Main_Menu))
#
#   case input
#   when "Next_Record"
#     @current += 1
#
#     if @current > @current_record.length-1
#       prompt.keypress("This is the last record on this list. Press any key to continue.")
#       @current -= 1
#       list_opportunities
#     else
#       list_opportunities
#     end
#   when "Previous_Record"
#     if @current == 0
#       prompt.keypress("\nThere are no previous records on this list. Press any key to continue.")
#       list_opportunities
#     else
#     @current -= 1
#     list_opportunities
#     end
#   when "Create_Request"
#     puts "CREATE REQUEST NOT READY- Coming Soon!"
#     exit
#   when "Delete_Opportunity"
#     @@user.delete_opportunity
#   when "Edit_Opportunity"
#     @@user.edit_opportunity
#   when "Main_Menu"
#     main_menu
#   end
# end
