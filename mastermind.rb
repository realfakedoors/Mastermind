class Mastermind
  require 'colorator'
  
  def initialize()
    @row_index = 0
    @colored_pegs = []
    @black_white_pegs = []
  end
  
  public
  
  def play
    code_generator
    instructions
    display_board
    try = 1
      until victory? || try > 12
        player_guess
        feedback
        display_board
        try += 1
      end
        if !victory? == true
          defeat
        end
  end
  
  def display_board
    puts "_".blue*22
    puts "|".blue+(" "*20)+"|".blue
    puts "|".blue+(" "*5)+"MASTERMIND".green+(" "*5)+"|".blue
    puts "|".blue+(" "*20)+"|".blue
    display_rows
    puts "|".blue+(" "*20)+"|".blue
    puts "-".blue*22
  end
  
  def instructions
    puts "_".green*47
    puts "|Welcome to Mastermind! The objective of this |".green
    puts "|game is to guess your opponent's secret code |".green
    puts "|in 12 or fewer tries! Enter four colors to   |".green
    puts "|make a guess. Options are: red/yellow/cyan/  |".green
    puts "|magenta/green/blue . You'll receive feedback |".green
    puts "|based on your guess. A pink peg means you    |".green
    puts "|guessed the color and position correctly, a  |".green
    puts "|green peg means the code contains your color,|".green
    puts "|but not in the same position as your guess.  |".green
    puts "|".green+(" "*45)+"|".green
    puts "|Your opponent has chosen a code, good luck!  |".green
    puts "-".green*47
  end
  
  private
  
  def display_rows
    12.times do
      if !@colored_pegs[@row_index].nil?
        puts "|".blue+"   " + @colored_pegs[@row_index].join("") + "   "+ @black_white_pegs[@row_index].join("") +"   "+(@row_index + 1).to_s.ljust(2,' ')+" |".blue
      else
        puts "|".blue+"   " + "oooo" + "   "+ "****" +"   "+(@row_index + 1).to_s.ljust(2,' ')+" |".blue
      end
      @row_index += 1
    end
  @row_index = 0
  end
  
  def code_generator
    @secret_code = []
    colors = ["o".blue, "o".green, "o".magenta, "o".cyan, "o".yellow, "o".red]
    4.times {@secret_code << colors.sample}
    @secret_code
  end
  
  def victory?
    if @black_white_pegs.include?(["*".magenta, "*".magenta, "*".magenta, "*".magenta])
      puts "Congratulations, you solved your opponent's code!".yellow
      return true
    end
    false
  end
  
  def defeat
    puts "Sorry, you were unable to guess your opponent's code!".yellow
    puts "Your opponent's code was: #{@secret_code.join("")}"
  end
  
  def feedback
    current_feedback = []
    @temp_guess.each_with_index do |peg,index|
      if peg == @secret_code[index]
        current_feedback << "*".magenta
        @temp_guess.slice(index)
      elsif @secret_code.include?(peg)
        current_feedback << "*".green
      else
        current_feedback << "*"
      end
    end
    @black_white_pegs << current_feedback.shuffle!
    @temp_guess = []
  end
  
  def advance_rows
    @row_index += 1
  end
  
  def player_guess
    @temp_guess = []
    until @temp_guess.length == 4
      i = gets.chomp
        case i
          when "red" then @temp_guess << "o".red
          when "yellow" then @temp_guess << "o".yellow
          when "cyan" then @temp_guess << "o".cyan
          when "magenta" then @temp_guess << "o".magenta
          when "green" then @temp_guess << "o".green
          when "blue" then @temp_guess << "o".blue
          else puts "Incorrect input, try again!"
        end
    end
    @colored_pegs << @temp_guess
  end
end

game = Mastermind.new()
game.play