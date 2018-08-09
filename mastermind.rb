require 'sinatra'
require 'sinatra/reloader' if development?

@row_index = 0
@colored_pegs = []
@black_white_pegs = []
@secret_code = []

def play
  code_generator
  try = 1

  until victory?
    player_guess
    feedback
    try += 1
    if try > 12
      defeat
      break
    end
  end
end

def code_generator
  colors = [:blue, :green, :magenta, :cyan, :yellow, :red]
  4.times {@secret_code << colors.sample}
end

def victory?
  if @black_white_pegs.include?(["*".magenta, "*".magenta, "*".magenta, "*".magenta])
    return true
  else false
  end
end

def defeat
  puts "Sorry, you were unable to guess your opponent's code!"
  puts "Your opponent's code was: #{@secret_code.join("")}"
end

def feedback
  current_feedback = []
  temp_secret_code = []
  @secret_code.each{|peg| temp_secret_code << peg}
  #first we check for a perfect location/color pairing, removing any matches.
  @temp_guess.each_with_index do |peg,index|
    if peg == temp_secret_code[index]
      current_feedback << "*".magenta
      temp_secret_code[index] = nil
    end
  end
  #then we check for each color pairing from the remaining pegs that weren't already paired.
  @temp_guess.each do |peg|
    if temp_secret_code.include?(peg)
      current_feedback << "*".green
      temp_secret_code[temp_secret_code.find_index(peg)] = "o"
    end
  end
  #then we fill any empty spots in the feedback response with plain pegs.
  until current_feedback.length == 4
    current_feedback << "*"
  end
  #shuffle the response to add a challenge for the guesser, and reset @temp_guess.
  @black_white_pegs << current_feedback.shuffle!
  @temp_guess = []
end

def player_guess
  @temp_guess = []
  until @temp_guess.length == 4
    i = gets.chomp
      case i
        when "red" then @temp_guess << :red
        when "yellow" then @temp_guess << :yellow
        when "cyan" then @temp_guess << :cyan
        when "magenta" then @temp_guess << :magenta
        when "green" then @temp_guess << :green
        when "blue" then @temp_guess << :blue
      end
  end
  this_guess = []
  @temp_guess.each{|peg| this_guess << peg}
  @colored_pegs << this_guess
end

enable :sessions

get '/' do
  erb :index
end
          
post '/' do
  @first_peg = params["first-peg"]
  @second_peg = params["second-peg"]
  @third_peg = params["third-peg"]
  @fourth_peg = params["fourth-peg"]
  erb :index
end