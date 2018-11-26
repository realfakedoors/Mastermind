require 'sinatra'
require 'sinatra/reloader' if development?

COLORS = [:blue, :green, :magenta, :cyan, :yellow, :red]

@secret_code = Array.new(4).map!{|peg| peg = COLORS.sample}
@turn = 1

@colored_pegs = []
@black_white_pegs = [[]]
#we start with a blank array in @black_white_pegs so its index == the current turn.

def play(pegs)
  pegs.map!{|peg| peg.to_sym}
  @colored_pegs << pegs
  feedback(pegs)
end

def game_over?
  true if victory? || defeat?
end

def victory?
  true if @black_white_pegs.include?([:black, :black, :black, :black])
end

def defeat?
  true if @turn > 12
end

def feedback(pegs)
  current_feedback = []
  temp_secret_code = []
  @secret_code.each{|peg| temp_secret_code << peg}
  #first we check for a perfect location/color pairing, removing any matches.
  pegs.each_with_index do |peg,index|
    if peg == temp_secret_code[index]
      current_feedback << :black
      temp_secret_code[index] = nil
    end
  end
  #then we check for each color pairing from the remaining pegs that weren't already paired.
  pegs.each do |peg|
    if temp_secret_code.include?(peg)
      current_feedback << :white
      temp_secret_code[temp_secret_code.find_index(peg)] = nil
    end
  end
  #then we fill any empty spots in the feedback response with plain pegs.
  until current_feedback.length == 4
    current_feedback << :empty
  end
  #we shuffle the response to add a challenge for the guesser.
  @black_white_pegs << current_feedback.shuffle!
end

enable :sessions

get '/' do
  erb :index
end
          
post '/' do
  unless game_over?
    pegs_entered = [ params["first-peg"], params["second-peg"], params["third-peg"], params["fourth-peg"] ]
    play(pegs_entered)
    @turn += 1
  end
  
  erb :index
end