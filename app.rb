require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/mastermind'

configure do
  enable :sessions
end

get '/' do
  session[:game] ||= Mastermind.new
  erb :index
end
          
post '/' do
  unless game.game_over?
    pegs_entered = [ params["first-peg"], params["second-peg"], params["third-peg"], params["fourth-peg"] ]
    session[:game].play(pegs_entered)
    session[:game].advance_turn
    erb :index, :locals => { :turn => session[:game].turn, :colored_pegs => session[:game].colored_pegs, :black_white_pegs => session[:game].black_white_pegs, :secret_code => session[:game].secret_code }
  else
    erb :game_over_screen
  end
  
end