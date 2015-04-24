require_relative "bot"

begin
  bot = Bot.new(:name => "Fred", :data_file => "fred.bot")
rescue
  puts "Alu Happened!"
  exit
end


puts bot.greeting

while input = gets and input.chomp != 'bye'
  puts "#{bot.name}=> #{bot.response_to(input)}"
  print "You=> "
end

puts bot.farewell