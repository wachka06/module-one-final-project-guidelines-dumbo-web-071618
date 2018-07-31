class Producer < ActiveRecord::Base
  has_many :casting_opportunities
  has_many :casting_requests
  has_many :actors, through: :casting_opportunities

  def full_name
    "#{first_name} #{last_name}"
  end

#Change .new to .create after testing line 12
#Change .new to .create
  def create_opportunity

    prompt = TTY::Prompt.new

    system "clear"
    @name = prompt.ask("Please enter character name.")

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

    CastingOpportunity.create(gender: @gender, age_range: @age, race: @race, salary: @salary, dates: @dates, status: "Active", producer_id: @@user.id, character_name: @name)

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
      puts "GOES TO UPDATE: COMING SOON!".yellow
    elsif input == 2
      main_menu
    end
  end
end
