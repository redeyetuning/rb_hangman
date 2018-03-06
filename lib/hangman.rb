#Hangman is a paper and pencil guessing game for two or more players. One player thinks of a word, 
#phrase or sentence and the other tries to guess it by suggesting letters or numbers, within a certain number of guesses.
 
class Hangman
  require "yaml"

	def self.load
		puts "\nDo you want to (L)oad a saved game or (P)lay a new game?"
  	if gets.chomp.downcase != "l"  
  		game = Hangman.new
  	else
  		loaded_game = File.read("save_game.txt")
  		puts "\nFile loaded!"
  		game = YAML::load(loaded_game) 	
  	end  
  	 
  	game.new
  end

  def new
  	play
  end

  private

  def initialize
  	@used_guesses ||= []
  	@remaining_guesses = 6
  	@word = pick_word(load_dictionary).chomp
  end

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
	  	save? 
	  end
  end

  def load_dictionary
    raise StandardError, "Dictionary file not found!" unless File.exist? "dictionary.txt"
    puts "Dictionary file loaded.\n\n"
    File.readlines "dictionary.txt"
  end

  def pick_word(dictionary)
    puts "A.I. has chosen a word from the dictionary:"
    word = dictionary.sample.downcase
    puts (@display_word = Array.new(word.length-1){"_"}).join(" ")
    return word
  end

  def get_guess
    puts "\nEnter your guess"
    guess = gets.chomp.downcase until guess_single_letter?(guess) && guess_unused?(guess)
    return guess
  end

  def guess_single_letter?(guess)
   guess =~ (/[a-z]/) && guess.length == 1  ? true : (puts "That is not a correct input. Please enter a single letter a-z!" if guess != nil)
  end

  def guess_unused?(guess)
    @used_guesses.include?(guess) && @used_guesses.length > 0 ? (puts "You have used that guess. Please try again!") : @used_guesses.push(guess)
  end
       
       
  def guess_matches?(word, guess)
    match = false
    word.each_char.with_index {|char,i| (@display_word[i] = char) && (match = true) if char == guess} 
    puts @display_word.join(" ")
    (@remaining_guesses -= 1) && (puts "\nIncorrect guess! You have #{@remaining_guesses} guesses left.") if !match
    return match
  end

  def save?
  	puts "\nDo you want to (S)ave the game or (P)lay on?"
  	if gets.chomp.downcase == "s"
  		save_file = File.open("save_game.txt", "w") 
  		puts save_string = YAML::dump(self)
  	
  		save_file.puts save_string
  		save_file.close
  		exit
  	end 
  end
  
  
  

end
 

Hangman.load

