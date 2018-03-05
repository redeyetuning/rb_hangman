#Hangman is a paper and pencil guessing game for two or more players. One player thinks of a word, 
#phrase or sentence and the other tries to guess it by suggesting letters or numbers, within a certain number of guesses.



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
	@used_guesses ||= []
	@used_guesses.include?(guess) && @used_guesses.length > 0 ? (puts "You have used that guess. Please try again!") : @used_guesses.push(guess)
end
	
	
def guess_matches?(word, guess)
	word.each_char.with_index {|char,i| @display_word[i] = char if char == guess}
end


word = pick_word(load_dictionary)

while @display_word.join =~ (/[_]/)
	guess_matches?(word,get_guess)
	puts @display_word.join(" ")
end