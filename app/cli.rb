def get_name
  system "clear"
  prompt = TTY::Prompt.new
  name = prompt.ask("Please enter your full name.")
  split_name = name.split(" ")
  @first_name = split_name[0]
  @last_name = split_name[1]
end

def producer_sign_in
  get_name
  Producer.new(first_name: @first_name, last_name: @last_name)
end

def actor_sign_in
  get_name
  Actor.new(first_name: @first_name, last_name: @last_name)
  end
