#
# #Trying to create a method that could be used to search by attribute in different places
# def search_by_attribute
#
#   prompt = TTY::Prompt.new
#   search_hash = {}
#
#   system "clear"
#   @gender = prompt.select("If you want to select by gender identity, please make your selection.", %w(Don't_Search_by_Gender Male Female TransMale TransFemale Genderqueer Something_Else Prefer_Not_to_Answer))
#
#   if @gender != nil || @gender != "Don't_Search_by_Gender"
#     search_hash[:gender] = @gender
#   end
#
#   system "clear"
#   choices = %w(16-21 21-30 30-35 35-45 45-50 50-60 60+)
#   @age = prompt.multi_select("If you want to select by age_range, please make your selection.", choices)
#
#   if @age != nil || @age.empty?
#     search_hash[:age_range] = @age
#   end
#
#   system "clear"
#   @race = prompt.select("If you want to select by race, please make your selection.", %w(Don't_Search_by_Race Asian Black/African Caucasian Hispanic/Latinx Native_American Pacific_Islander Prefer_Not_to_Answer))
#
#   if @race != nil || @race != "Don't_Search_by_Race"
#     search_hash[:race] = @race
#   end
#
#   system "clear"
#   @salary = prompt.select("If you want to select by salary, please make your selection.", %w(Don't_Search_by_Salary Unpaid Less_than_5k 5k-50k 50k-150k 150k-500k More_than_500k))
#
#   if @salary != "Don't_Search_by_Salary"
#     search_hash[:salary] =  @salary
#   end
#
#   system "clear"
#   choices = %w(January February March April May June July August September October November December)
#   @dates = prompt.multi_select("If you want to select by dates, please make your selection.", choices)
#
#   if @dates != nil
#     search_hash[:dates] = @dates
#   end
#
# search_hash_with_strings = search_hash.each_with_object({}) { |(key,value), new_hash| new_hash[key] = value.to_s }
#
#   @current_record =  CastingOpportunity.where(search_hash_with_strings)
#   @current = 0
#
#   if @current_record.empty?
#     input = prompt.yes?("None of the casting opportunities match your query. Would you like to run another search?")
#     if input == true
#       search_by_attribute
#     else main_menu
#     end
#   end
#
#   list_opportunities
# end
