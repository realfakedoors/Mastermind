class Mastermind
  
  attr_accessor :turn, :colored_pegs, :black_white_pegs, :secret_code
  
  def initialize
    @turn = 0
    @colored_pegs = []
    @black_white_pegs = []
    
    generate_code
  end
  
  def generate_code
    colors = [:blue, :green, :magenta, :cyan, :yellow, :red]
    @secret_code = Array.new(4).map!{|peg| peg = colors.sample}
  end

  def play(pegs)
    pegs.map! do |peg|
      #we substitute blank pegs for any "nil" entries to prevent incomplete input.
      peg == nil ? :blank : peg.to_sym
    end
    
    @colored_pegs << pegs
    feedback(pegs)
  end
  
  def advance_turn
    @turn += 1
  end

  def victory?
    true if @black_white_pegs.include?([:black, :black, :black, :black])
  end

  def defeat?
    true if @turn > 11
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

end