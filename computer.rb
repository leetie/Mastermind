require_relative 'typer'
class Computer
  include Typer
  def initialize
    @wrong_guess_array = []
    @right_guess_array = []
    @available_guesses = [1,2,3,4,5,6,7,8]
    @first_guess = [1,2,3,4]
    @game = MasterMind.game[0]
  end
  def get_feedback
    @game.guess_feedback
  end

  def make_guess
    @first_guess
    @guess = []
    4.times do |i|
      @guess << rand(1..8)
    end
    @guess
  end

end