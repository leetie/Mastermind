require 'colorize'
require_relative 'typer'
require_relative 'computer'

include Typer
class MasterMind < Computer
  attr_reader :guess_feedback
  include Enumerable
  include Typer
  @@game = []
  def self.game 
    @@game
  end
  def initialize
    @code = [1,2,3,4]
    @guess_feedback = ["X","X","X","X"]
    @@game << self
  end

  def random_code
    @code = []
    4.times do |i|
      @code << rand(1..8)
    end
  end

  def prompt_guess
    "\t______________
        |Guess the code|".cyan.typer(0.03)
    @guess = gets.chomp.split("").map! { |str| str.to_i }
  end

  def check_code
    @guess.each_with_index { |item, index| 
      if @code.include? item
        @guess_feedback[index] = "CLOSE"
      end
      if @code[index] == item
        @guess_feedback[index] = "RIGHT"
      end
      if @code.any? {|i| i == item} == false
        @guess_feedback[index] = "X"
      end
    }
  end

  def win?
   @guess == @code
  end

  def get_turns
    loop {
      "\tPlease choose amount of turns 4-12".cyan.typer
      @turn_length = gets.chomp.to_i
      if @turn_length > 12 || @turn_length < 4
        puts "\tPlease enter a number between 4 and 12".red 
      else break
      end
    }
  end

  def play_again?
    "\tWould you like to play again?".cyan.typer(0.025)
    answer = gets.chomp.downcase
    if answer == "y" || answer == "yes"
      start
    elsif answer == "n" || answer == "no"
      puts "Thanks for playing!"
      
    end
  end

  def game_loop(comp=false)
    until @turn_length == 0
      prompt_guess unless comp == true
      if comp == true
        @guess = computer.make_guess
      end
      if @guess.length != 4
        "Please enter 4 digits".cyan.typer
        redo
      end
      check_code
      if win?
        "\tCongrats, you win!!".cyan.typer
        wingraphic = File.read('./wingraphic.txt')
        puts wingraphic.red
        play_again?
        break
      end
      @guess.each_with_index do |item, index|
        if @guess_feedback[index] == "X"
          print "|#{item.to_s.red}|"
        elsif @guess_feedback[index] == "CLOSE"
          print "|#{item.to_s.white}|"
        elsif @guess_feedback[index] == "RIGHT"
          print "|#{item.to_s.green}"
        end
      end
      puts ""
      @turn_length -= 1
    end
    if !win?
    "\tYou lose!".cyan.typer
    losegraphic = File.read('./losegraphic.rb')
    puts losegraphic
    play_again?
    exit!
    end
  end

  def start 
    
    get_turns
    "Would you like to make or break the code? [1/2]".red.typer
    answer = gets.chomp.to_i
    if answer == 2
      random_code
      game_loop
    elsif answer == 1
      computer = Computer.new
      "Enter your code".red.typer
      @code = gets.chomp.split("")
      @code.map! {|i| i.to_i}
      puts "The code is: #{@code.join.to_s.green}. (Don't worry we won't tell the computer)"
      until @turn_length == 0
        puts  "\t _______________
        |Guess the code|".cyan
          @guess = computer.make_guess
          "#{@guess[0]}...#{@guess[1]}...#{@guess[2]}...#{@guess[3]}".red.typer(0.1)
        check_code
        if win?
          "\tThe Computer Won!!".cyan.typer
          computerwinpic = File.read('./computerwin.txt')
          puts computerwinpic.red
          play_again?
          break
        end
        @guess.each_with_index do |item, index|
          if @guess_feedback[index] == "X"
            print "|#{item.to_s.red}|"
          elsif @guess_feedback[index] == "CLOSE"
            print "|#{item.to_s.white}|"
          elsif @guess_feedback[index] == "RIGHT"
            print "|#{item.to_s.green}"
          end
        end
        puts ""
        sleep 2
        @turn_length -= 1
      end
      if !win?
      "\tYou Win!".cyan.typer
      losegraphic = File.read('./losegraphic.rb')
      wingraphic = File.read('./sadcomputer.txt')
      puts wingraphic.red
      play_again?
      exit!
      end
      
    else puts "Enter the number 1 or 2"
    end
  end
    

  def hello_message
    "\tHello and welcome to".cyan.typer(0.03)
    "*************************************************************************".red.typer(0.01)
    3.times {puts ""}

    graphic = File.read('./graphic.txt')
    graphic.red.typer(0.001)
    "*************************************************************************".red.typer(0.01)

    puts ""
    message = "\tRules are simple. You must guess a 4 digit code. Each digit in the code can be numbers 1-8
    If a number is correctly guessed and is in the right position, it will be displayed as green. 
    If a number is correctly guessed but in the wrong position, it will be displayed as white.
    An incorrect guess will be displayed as red."
    message.cyan.underline.typer(0.025)
  end

end

game = MasterMind.new
# computer = Computer.new
# puts computer.get_feedback
game.hello_message
game.start
