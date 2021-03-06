require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/mastermind'

configure do
  enable :sessions
end

#when the page is first loaded.
get '/' do
  session[:game] ||= Mastermind.new
  erb :index, :locals => { :colored_pegs => session[:game].colored_pegs, :black_white_pegs => session[:game].black_white_pegs }
end

#when a guess is submitted.
post '/' do
  pegs_entered = [ params["first-peg"], params["second-peg"], params["third-peg"], params["fourth-peg"] ]
  session[:game].play(pegs_entered)
  session[:game].advance_turn
  
  if session[:game].victory?
    template = :victory_screen
  elsif session[:game].defeat?
    template = :defeat_screen
  else
    template = :index
  end
  
  erb template, :locals => { :colored_pegs => session[:game].colored_pegs, :black_white_pegs => session[:game].black_white_pegs, :turn => session[:game].turn, :secret_code => session[:game].secret_code }
end

#a route for the 'New Game' button on victory/defeat templates that resets the session.
post '/new_game' do
  session[:game] = Mastermind.new
  erb :index, :locals => { :colored_pegs => session[:game].colored_pegs, :black_white_pegs => session[:game].black_white_pegs }
end