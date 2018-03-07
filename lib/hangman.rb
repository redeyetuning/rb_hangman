#Hangman is a paper and pencil guessing game for two or more players. 
#- One player thinks of a word 
#- The other player tries to guess the word it by suggesting letters or numbers
#- A certain number of guesses are allowed to find all matching letters, after which the game is lost

# This class contains the popular Hangman game.
class Hangman
  require "yaml"
  require "rdoc"

	# This function allows the user to load an exisitng saved instance of the Hangman class or initialize a new one.
	def self.load
		puts "\nDo you want to (L)oad a saved game or (P)lay a new game?"
  	if gets.chomp.downcase != "l" then game = Hangman.new  
  	else
  		begin
  			if loaded_game = File.read("save_game.txt")
  				game = YAML::load(loaded_game)
  				puts "\nFile loaded!"
  			end  	
  		rescue 
  			puts "\nFile not found! Starting new game.\n\n"
  			game = Hangman.new
  		end 
  	end  
  	game.new
  end

  # Helper method used to start game play from Private methods.
  def new
  	play
  end

  private

  # Initializes requried instance variables.
  def initialize
  	@used_guesses ||= []
  	@remaining_guesses = 6
  	@word = pick_word(load_dictionary).chomp
  end

  # Initializes a guessing loop until the game is lost or won.
  def play
    loop do 
    	guess_matches?(@word,get_guess)
    	if @remaining_guesses == 0 
    		puts "\nSorry you loose! The correct word was \"#{@word}\""
    		break 
 	    elsif @display_word.join =~ (/^[a-z]+$/) 
 	    	puts "\nCongratulations you won! The winning word was \"#{@word}\""
 	    	break
 	    end 
	  end
  end

  # Checks for dictionary.txt file and loads it.
  def load_dictionary
    raise StandardError, "Dictionary file not found! Please copy a dictionary.txt file into root folder." unless File.exist? "dictionary.txt"
    puts "Dictionary file loaded.\n\n"
    File.readlines "dictionary.txt"
  end

  # Randomly selects a word from the dictionary.
  def pick_word(dictionary)
    puts "A.I. has chosen a word from the dictionary:"
    word = dictionary.sample.downcase
    puts (@display_word = Array.new(word.length-1){"_"}).join(" ")
    return word
  end

  # Takes an input from the user.
  def get_guess
    puts "\nEnter your guess now or type \"SAVE\" to save game."
    guess = gets.chomp.downcase until save?(guess) or ( guess_single_letter?(guess) && guess_unused?(guess) )
    return guess
  end

  # Checks if an input is a single a-z letter.
  def guess_single_letter?(guess)
   guess =~ (/[a-z]/) && guess.length == 1  ? true : (puts "That is not a correct input. Please enter a single letter a-z!" if guess != nil)
  end

  # Checks whether an input guess has already been used.
  def guess_unused?(guess)
    @used_guesses.include?(guess) && @used_guesses.length > 0 ? (puts "You have used that guess. Please try again!") : @used_guesses.push(guess)
  end
       
  # Checks whether an input guess matches and characters in the computer selected word.     
  def guess_matches?(word, guess)
    match = false
    word.each_char.with_index {|char,i| (@display_word[i] = char) && (match = true) if char == guess} 
    puts @display_word.join(" ")
    (@remaining_guesses -= 1) && (puts "\nIncorrect guess! You have #{@remaining_guesses} guesses left.") if !match
    return match
  end
	
	# Permits the user to save a game and exit.
  def save?(guess)
  	
  	if guess == "save"
  		save_file = File.open("save_game.txt", "w") 
  		save_file.puts YAML::dump(self)
  		save_file.close
  		puts "\nGame saved!"
  		exit
  	end 
  end

end
 

Hangman.load(guesses)

